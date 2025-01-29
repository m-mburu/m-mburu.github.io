import os
import time

from selenium import webdriver
from selenium.webdriver.chrome.options import Options

# Set up Chrome options
options = Options()
download_path = r"data/diaspora_remittances.csv"
options.add_argument("--headless")
options.add_experimental_option("prefs", {
    "download.default_directory": download_path,
    "download.prompt_for_download": False,
    "download.directory_upgrade": True,
    "safebrowsing.enabled": True
})

driver = webdriver.Chrome( options=options)

url = 'https://www.centralbank.go.ke/diaspora-remittances/'

try:
    driver.get(url)
    time.sleep(3)  # Allow some time for the page to load

    # Find the download button by its class and click it
    download_button =driver.find_element(BY_CSS_SELECTOR, 'a[href*="diaspora_remittances"]')
    download_button.click()

    # Function to check if the download is complete
    def is_download_complete(download_path):
        # Check if there are any files with ".crdownload" extension
        return not any([f for f in os.listdir(download_path) if f.endswith('.crdownload')])

    # Wait for the download to complete
    while not is_download_complete(download_path):
        time.sleep(1)  # Check every second

finally:
    driver.quit()
