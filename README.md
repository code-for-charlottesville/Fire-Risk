Join our Meetup group here: https://www.meetup.com/Code-for-Charlottesvile/

Join our Slack page: codeforcville.slack.com

Our slides for tonight: https://tinyurl.com/CFChacknight

# Building a Fire Risk Score for the Charlottesville Fire Department and a Website to Educate Citizens About Their Fire Risk

**Project Status:** Active

**Links:**

[Charlottesville Fire Department](https://www.charlottesville.org/departments-and-services/departments-a-g/fire-department)

[Charlottesville Open Data Portal](https://opendata.charlottesville.org/)

[Code for Charlottesville](codeforcharlottesville.org)

**Schedule:** We will be working with this dataset on

* Tuesday, November 5, 6:30-9pm, Center for Civic Innovation

* Tuesday, November 19, 6:30-9pm, Dell 1, UVA

* Tuesday, December 3, 6:30-9pm, Center for Civic Innovation

**Plan for Nov. 5 hack night:** For the project kickoff this Tuesday, our goal will be to familiarize everyone with the data and the goals, to have a brainstorming session about the website, and for Lucas to answer as many questions as the participants have. 

## Introduction and Objective
We're working with Lucas Lyons at the Fire Department, and he's given us two goals.

### Goal 1: We will generate fire severity risk scores for every parcel of land in Charlottesville
We will use all the parcel-level data from the Charlottesville open data portal (https://opendata.charlottesville.org/) on the individual parcels that comprise the map of Charlottesville. For each parcel, we have information on the properties located on that parcel, such as the age and square footage of the buildings. We also have access to historical fire data. We will construct a "fire risk score" that tells us the likely severity of a fire given the parcel where the fire is happening. 

Lucas wants us to push these scores to the Charlottesville open data portal so that the Fire Dept and the Dispatcher (the 911 call center) can have immediate access to the scores. The Fire Dept wants to display the risk score on monitors inside the fire trucks on their way to a fire so the firefighters can know how bad the fire is probably going to be. The 911 call center wants to use the score to know how many firetrucks to dispatch to a call. 

We're going to build the following **deliverables**:

1. Using a formula provided by the Fire Dept, we will create a dataset of fire risk scores for every parcel in Charlottesville, and push it to the Charlottesville open data portal.

2. We will write clear, accessible "how-to" documentation for how we built the risk score, so that it is easy for Lucas or other city employees to update the scores when new data becomes available.

3. We will develop a web-based platform for changing the formula or adding new data and pushing updated risk scores to the open data portal.

4. We will use the historical fire data to build a machine learning model to forecast risk scores, and we will compare these ML scores to the scores using the Fire Dept's formula.

### Goal 2: We will create a website that allows Charlottesville residents to look up their property, see their fire risk score, and understand what it means
The purpose of the website is to educate people on the factors that can lead to fires, so that they take steps to fireproof their properties and prevent fires.

We're going to build the following **deliverables**:

1. We'll create a well-designed website that describes the factors associated with higher fire risk. We'll write text, include images, and maybe make videos.

2. We're going to include a map that displays the risk score of any parcel someone clicks on, with a search bar where someone can enter their address.

## Data
All data for this project will come from the Charlottesville open data portal

| DATASET    | FIELD                | URL                                                                                | Open Portal Dataset               | Field Alias@URL               |
|------------|----------------------|------------------------------------------------------------------------------------|-----------------------------------|-------------------------------|
| Fire_model | GPIN                 | https://opendata.charlottesville.org/datasets/parcel-area-details                  | Parcel Area Details               | GeoParcelIdentificationNumber |
|            | Zoning               | https://opendata.charlottesville.org/datasets/parcel-area-details                  | Parcel Area Details               | Zoning                        |
|            | Oldest_Structure     | https://opendata.charlottesville.org/datasets/real-estate-commercial-details/data  | Real Estate (Commercial Details)  | YearBuilt                     |
|            |                      | https://opendata.charlottesville.org/datasets/real-estate-residential-details      | Real Estate (Residential Details) | YearBuilt                     |
|            | Area_sqFT            | https://opendata.charlottesville.org/datasets/real-estate-residential-details      | Real Estate (Residential Details) | SquareFootageFinshedLiving    |
|            |                      |                                                                                    |                                   |                               |
| Desired    |                      | https://opendata.charlottesville.org/datasets/master-address-table/data            | Master Address Table              |                               |
|            | Commercial_Use_Code  | https://opendata.charlottesville.org/datasets/real-estate-commercial-details/data  | Real Estate (Commercial Details)  | UseCode                       |
|            | Number_of_Stories    | https://opendata.charlottesville.org/datasets/real-estate-commercial-details/data  | Real Estate (Commercial Details)  | NumberOfStories               |
|            | Residential_Use_Code | https://opendata.charlottesville.org/datasets/real-estate-residential-details/data | Real Estate (Residential Details) | UseCode                       |
|            | Residential_Style    | https://opendata.charlottesville.org/datasets/real-estate-residential-details/data | Real Estate (Residential Details) | Style                         |
|            | Residential_Heating  | https://opendata.charlottesville.org/datasets/real-estate-residential-details/data | Real Estate (Residential Details) | Heating                       |
|            | Residential_Basement | https://opendata.charlottesville.org/datasets/real-estate-residential-details/data | Real Estate (Residential Details) | BasementType                  |
|            | Residential_Stories  | https://opendata.charlottesville.org/datasets/real-estate-residential-details/data | Real Estate (Residential Details) | NumberOfStories               |
