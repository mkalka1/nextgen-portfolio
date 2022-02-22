# DSC 510 - Summer Semester 2020
# Week 10 Course Final Project - Weather Program
# Author: Manish Kalkar
# 08/07/2020

import requests
import json

global zipcode, zipcd, response, querystring


# Function to process weather API to retrieve Weather data
def process_weather_api(userinput):

    global zipcode

    # If user select the Zip Code option
    if userinput == 1:

        zipcode = input("Please enter the 5 digit Zip Code: ")

        # Validate Zip Code is 5 digits
        if len(zipcode) != 5:  # if user miss entering 5 Digits in Zip Code
            print("US Zip Code must be 5 digits. Please try again")
            main()
        else:
            try:
                zipcode = int(zipcode)
            except ValueError:  # validating if user enters anything other than integer
                print("Invalid Zip Code. Please try again")
                main()
            else:
                retrieve_weather_data(zipcode)  # Call function to fetch weather data based on valid Zip Code

    else:  # If user select the City option

        # Prompt user to enter the City name.
        city = input("Please enter the City. Recommended Format: 'City, State Code, US' OR 'City, Country Code': ")
        retrieve_weather_data(city)  # Call function to fetch weather data based on valid City


# Function to retrieve the Weather Data
def retrieve_weather_data(ziporcity):

    global zipcd, response, querystring

    # Define the url
    url = "http://api.openweathermap.org/data/2.5/weather"

    # Headers to be submitted for http request
    headers = {'cash-control': 'no-cache'}

    # Build the query string based on either Zip Code or City
    if isinstance(ziporcity, int):

        zipcd = ziporcity

        # querystring to be submitted to the url with Zip Code
        querystring = {"zip": zipcd,
                       "APPID": "23b48d8cd612eab83ae16d5799ce3b3a"}
    else:

        # querystring to be submitted to the url with City
        querystring = {"q": ziporcity,
                       "APPID": "23b48d8cd612eab83ae16d5799ce3b3a"}

    # Try blocks to ensure that the request was successful
    # Try blocks when establishing connections to the webservice
    try:
        # Uses the Request library to make a GET request of the API
        response = requests.request("GET", url, headers=headers, params=querystring)
    except requests.exceptions.Timeout:
        print("It is taking too long to retrieve weather data. Please try again later")
        quit()
    except requests.exceptions.TooManyRedirects:
        print("Too many place to look out for weather data. Please try again later")
        quit()
    except requests.exceptions.ConnectionError:
        print("Connection error. Please try again later")
        quit()
    except requests.exceptions.RequestException:
        print("Weather data retrieval error. Please try again later")
        quit()

    # Try blocks to ensure proper handling of JSON Error Codes
    try:
        # json.loads() returns the python dictionary object.
        data = json.loads(response.text)

        if response.status_code == 200:  # JSON Status Code 200 represents successful data retrieval
            # Call function to print the weather data
            print_weather_data(data)
        else:
            if isinstance(ziporcity, int):
                print("Invalid Zip Code. Please try again")
            else:
                print("Invalid City. Please try again")

        # Allow the user to run the program multiple times to allow them to look up weather conditions for multiple
        # locations.
        main()

    except Exception as e:
        print(e)


# Function to print weather data
def print_weather_data(weatherdata):

    # Converting temperature from Kelvin to Fahrenheit
    temp = int(round((weatherdata['main']['temp'] - 273.15) * 9 / 5 + 32))
    hightemp = int(round((weatherdata['main']['temp_max'] - 273.15) * 9 / 5 + 32))
    lowtemp = int(round((weatherdata['main']['temp_min'] - 273.15) * 9 / 5 + 32))

    # Parse the JSON data to print weather into readable format
    print("\n")
    print("Current Weather Conditions for", weatherdata['name'])
    print("----------------------------------------------")
    print("Current Temperature:", temp, "degrees F")
    print("High Temperature:", hightemp, "degrees F")
    print("Low Temperature:", lowtemp, "degrees F")
    print("Pressure:", weatherdata['main']['pressure'], "hPa")
    print("Humidity:", weatherdata['main']['humidity'], "%")
    print("Cloud Cover:", weatherdata['weather'][0]['main'], "-", weatherdata['weather'][0]['description'])

    # Print a message to the user indicating the connection was successful.
    print("\n")
    print("Connection to the Web Service was successful. Weather data was successfully retrieved.")
    print("\n")


def main():

    # Prompt the user for their city or zip code
    zipcityoption = input("Enter 1 for Zip Code, 2 for City and State, 3 to Quit: ")

    # Validate if user miss entering the option
    if zipcityoption == "":
        print("Invalid option - You must enter value 1 for Zip Code, 2 for City and State Or you can enter 3 to Quit")
        main()
    else:
        pass

    # Validate if user enters anything other than integer
    try:
        zipcityoption = int(zipcityoption)
    except ValueError:
        print("Invalid option - You must enter value 1 for Zip Code, 2 for City and State Or you can enter 3 to Quit")
        main()

    # Validating user input = 1, 2 or 3.
    # If within the range, call process weather API function
    while zipcityoption in range(1, 4):

        if zipcityoption == 3:
            quit()
            break
        else:
            process_weather_api(zipcityoption)
            break
    else:
        print("Invalid option - You must enter value 1 for Zip Code, 2 for City and State Or you can enter 3 to Quit")
        main()


if __name__ == "__main__":
    print("-------------------------------------------------")
    print("Welcome to the Online Weather Forecast")
    print("Retrieve weather forecast for today based on either Zip Code or City, State")
    print("-------------------------------------------------")
    main()
