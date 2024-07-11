import re
import pandas as pd
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
import time

import re
import pandas as pd
from bs4 import BeautifulSoup

def extract_dividend_information(html_content):
    # Parse the HTML content
    soup = BeautifulSoup(html_content, 'html.parser')

    # Find all h3 tags and their following p tag children
    entries = soup.find_all('h3')

    # Initialize lists to store the extracted information
    companies = []
    dividends = []
    announce_dates = []
    book_closure_dates = []
    payment_dates = []

    # Regular expressions to match the specific pieces of information
    dividend_re = re.compile(r'Dividend of Kes\.(\d+\.\d+)')
    announce_date_re = re.compile(r'on (\d+-[A-Za-z]+-\d+)')
    book_closure_date_re = re.compile(r'Books Closure (\d+-[A-Za-z]+-\d+)')
    payment_date_re = re.compile(r'Payment Date; (\d+-[A-Za-z]+-\d+)')

    # Extract information from each h3 and p tag pair
    for h3 in entries:
        company_name = h3.text.strip()
        p = h3.find_next_sibling('p')
        if p:
            text = p.text
            
            # Extract information using regular expressions
            dividend_match = dividend_re.search(text)
            announce_date_match = announce_date_re.search(text)
            book_closure_date_match = book_closure_date_re.search(text)
            payment_date_match = payment_date_re.search(text)
            
            companies.append(company_name)
            dividends.append(dividend_match.group(1) if dividend_match else None)
            announce_dates.append(announce_date_match.group(1) if announce_date_match else None)
            book_closure_dates.append(book_closure_date_match.group(1) if book_closure_date_match else None)
            payment_dates.append(payment_date_match.group(1) if payment_date_match else None)

    # Create a DataFrame from the extracted information
    data = {
        'Company': companies,
        'Dividend': dividends,
        'Announce Date': announce_dates,
        'Book Closure Date': book_closure_dates,
        'Payment Date': payment_dates
    }

    df = pd.DataFrame(data)
    return df
  


# Setup the Chrome WebDriver
driver_path = '/usr/bin/google-chrome-stable'
driver = webdriver.Chrome()
# URL of the page to navigate
url = 'https://www.nse.co.ke/corporate-actions/'
driver.get(url)

# Open the URL
driver.get(url)

# Close or accept the cookie consent bar if present
def close_cookie_consent():
    try:
        cookie_consent_button = driver.find_element(By.ID, 'wt-cli-accept-all-btn')
        cookie_consent_button.click()
        time.sleep(2)  # Wait for the cookie consent bar to disappear
    except Exception as e:
        print(f"No cookie consent button found or could not be closed: {e}")

close_cookie_consent()


# List to store DataFrames from each page
dfs = []

# Loop through the pages
while True:
    # Get the HTML content of the current page
    html_content = driver.page_source
    
    # Extract dividend information and append to the list
    df = extract_dividend_information(html_content)
    dfs.append(df)
    
    # Try to find the "Next" button and click it
    try:
        next_button = driver.find_element(By.XPATH, '//div[@class="nse_paginations"]/ul/li/div[contains(text(),"Next")]')
        print(f"Next button found: {next_button.text}")
        if 'inactive' in next_button.get_attribute('class'):
            break  # Exit loop if "Next" button is disabled
        next_button.click()
        time.sleep(2)  # Wait for the page to load
    except Exception as e:
        print(f"Error finding next button: {e}")
        break  # Exit loop if "Next" button is not found





# Close the WebDriver
driver.quit()

# Combine all DataFrames into one
final_df = pd.concat(dfs, ignore_index=True)

final_df.to_csv('data/dividends.csv', index=False)
        
