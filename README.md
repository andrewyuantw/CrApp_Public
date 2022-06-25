# CrApp_Public

## Overview

crApp is a mobile application designed to address the vastly different qualities in restrooms across academic buildings in the UMD College Park campus. crApp would offer students the ability to leave reviews for each academic building's restrooms anonymously, and the application would also include a map with each restroom and their rating. Additionally, there will be a button that will route you to the closest restroom depending on your current location.

## Current Design / Wireframe

Users will go through a log-in page first, with log-in handled by Firebase Auth. Reviews will be anonymous, so the only reason for logging in is so users can have a list of "favorite" bathrooms. As a stretch goal, I've thought about the addition of certain accomplishment badges, which would require some sort of mechanism that differentiates each user. 

The application would then have three screens described below.

### Map Screen

This screen includes a map (currently through Google Maps API), markers for each restroom location, and a "CRAP!" button towards the bottom center of the screen. I am currently using a JSON file from umd.io's site that includes coordinates for each UMD academic building to populate the map with markers. Upon clicking each marker, a popover will appear and display information such as building name and star rating (star rating yet to be implemented). Upon clicking each popover, users will be redirected to each site's dedicated Review page (described in the next section). Upon clicking the "CRAP!" button, a bottom modal will pop up with sliders so users can indicate their preference of star rating vs. distance to restroom. Using the Google Maps API, the app would then route users to the best restroom.

### Review Screen

This screen includes a scrollable list of reviews for each location. Reviews will be kept simple - numerical star rating and then a text-form review. Comments and likes will not be allowed for now. Users will also be able to leave a review on this page as well. This page will also include a heart icon towards the top so that users may favorite a location that they like. 

### Profile Screen

This screen will include a scrollable list of your favorite locations, and then a logout button. Nothing too fancy here to keep the application simple. 
