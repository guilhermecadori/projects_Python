# Exc 1
"""
    Complete the function/method so that it returns the url with anything after the anchor (#) removed.
    
    Examples:
        "www.codewars.com#about" --> "www.codewars.com"
        "www.codewars.com?page=1" -->"www.codewars.com?page=1"
"""

# Function
def remove_url_anchor(url):
    # Find "#", break string into two and return firt half only
    if url.find("#") > -1:
        url_clean = url[:url.find("#")]
        return url_clean
    return url

# Test
urls =["www.codewars.com#about", "www.codewars.com?page=1", "www.codewars.com/katas"]

for url in urls:
    print(remove_url_anchor(url))
    