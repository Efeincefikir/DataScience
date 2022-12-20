import streamlit as st
import pandas as pd
import pickle
from sklearn.neighbors import NearestNeighbors
from scipy.sparse import csr_matrix
import requests

# Opening Containers for Streamlit
header = st.container()
dataset = st.container()
features = st.container()

with header:  # Defining header

    # Loading necessary data
    ds = pickle.load(open("ds.pkl", "rb"))
    movieC = pickle.load(open("movie_list.pkl", "rb"))
    similarityC = pickle.load(open("similarity.pkl", "rb"))
    posters_item = pd.read_csv("poster_item.csv")
    csr_data = csr_matrix(ds.values)
    ds.reset_index(inplace=True)
    knn = NearestNeighbors(metric='cosine', algorithm='brute', n_neighbors=20, n_jobs=-1)
    knn.fit(csr_data)


    def fetch_poster(movie_id):
        url = "https://api.themoviedb.org/3/movie/{}?api_key=8265bd1679663a7ea12ac168da84d2e8&language=en-US".format(
            movie_id)
        data = requests.get(url)
        data = data.json()
        poster_path = data['poster_path']
        full_path = "https://image.tmdb.org/t/p/w500/" + poster_path
        return full_path


    # Writing for Streamlit
    st.title("Welcome to my Movie Recommendation System!")
    st.write(" I am Efe İncefikir. My number is 2018556453 and this is for my final project in Çukurova University")
    st.write("This recommendation system will have two options, Item-Based Collaborative filtering, and Content-Based "
             "Filtering")

with dataset:
    st.title("I have two databases to work here. I will use both of them for different types of filtering.")
    st.write("Lets look at the first 20 movies in the first database, one for the collaborative filtering")
    moviesItem = pd.read_csv("movies.csv")
    st.write(moviesItem.head(20))
    st.write("Now let's look at the first 20 movies in the Content-Based database")
    st.write(movieC.head(20))
    st.write("Since I didn't use the genre column for collaborative filtering, let's use it to show how many movies "
             "some genres have ")
    st.subheader("Movies counts for genres (Not all genres are included)")  # Creating bar chart
    genre_dist = pd.DataFrame(moviesItem["genres"].value_counts()).head(25)
    st.bar_chart(genre_dist, 1000)

    # Creating radio buttons
    movie_way = st.radio(
        "Which is your go-to way to watch some movies?",
        ('On TV', 'On PC', 'On Phone', "In Theaters"))

    if movie_way == 'On TV':
        st.write('The most comfortable choice!')
    elif movie_way == "On PC":
        st.write(" You are using it all day, might as well watch some movies!")
    elif movie_way == "On Phone":
        st.write("You are probably on the go a lot!")
    elif movie_way == "In Theaters":
        st.write("Nothing beats the classic!")

with features:
    st.title("Now is the time to recommend some movies!")

    sel_col, dis_col = st.columns(2)
    filter_choose = sel_col.selectbox("Which filtering you want to use",
                                      options=["Choose a Filtering Type", "Item-Based Collaborative", "Content-Based"],
                                      index=0)
    if filter_choose == "Item-Based Collaborative":

        input_feature = sel_col.text_input("Please enter a movie you like (Item Based)")


        def get_movie_recommendation(movie_name):  # Item-Based Filtering Recommendation
            n_movies_to_recommend = 20
            movie_list = moviesItem[moviesItem['title'].str.contains(movie_name)]
            if len(movie_list):
                movie_idx = movie_list.iloc[0]['movieId']
                movie_idx = ds[ds['movieId'] == movie_idx].index[0]
                distances, indices = knn.kneighbors(csr_data[movie_idx], n_neighbors=n_movies_to_recommend + 1)
                rec_movie_indices = sorted(list(zip(indices.squeeze().tolist(), distances.squeeze().tolist())),
                                           key=lambda x: x[1])[:0:-1]
                recommend_frame = []

                for val in rec_movie_indices:
                    movie_idx = ds.iloc[val[0]]['movieId']
                    idx = moviesItem[moviesItem['movieId'] == movie_idx].index
                    recommend_frame.append({'Title': moviesItem.iloc[idx]['title'].values[0], 'Distance': val[1]})
                df = pd.DataFrame(recommend_frame, index=range(1, n_movies_to_recommend + 1))
                return df
            else:
                return "No movies found. Please check your input"


        answer = get_movie_recommendation(input_feature)
        if input_feature:
            st.write(answer)



    elif filter_choose == "Content-Based":
        input_feature = sel_col.text_input("Please enter a movie you like (Content Based)")


        def recommend(movie):  # Content-Based Filtering Recommendation
            n_movies_to_recommend = 7
            try:
                index = movieC[movieC['title'] == movie].index[0]
            except IndexError:
                st.write("No movies found. Please check your input.")
                st.stop()

            recommend_frame = []
            poster_frame = []
            distance_frame = []
            distances = sorted(list(enumerate(similarityC[index])), reverse=True, key=lambda x: x[1])
            for i in distances[1:n_movies_to_recommend + 1]:
                movie_id = movieC.iloc[i[0]].movie_id
                recommend_frame.append(movieC.iloc[i[0]].title)
                poster_frame.append(fetch_poster(movie_id))
                distance_frame.append(i[1])



            return recommend_frame, poster_frame, distance_frame


        if input_feature:
            recommended_movie_names, recommended_movie_posters, movie_distances = recommend(input_feature)
            col_list = [col1, col2, col3, col4, col5, col6, col7] = st.columns(7)
            for i in range(7):
                with col_list[i]:
                    st.text(recommended_movie_names[i])
                    st.image(recommended_movie_posters[i])
                    st.text(movie_distances[i])



    else:
        st.write("Let's find you a movie to watch!")
