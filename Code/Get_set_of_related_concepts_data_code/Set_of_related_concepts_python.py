import requests
import json
import logging
import sys
import os.path
import re
import csv
agreement = 'https://'
language = 'en'
organization = '.wikipedia.org/w/api.php'

API_URL = agreement + language + organization

program = os.path.basename(sys.argv[0])
logger = logging.getLogger(program)
logging.basicConfig(format='%(asctime)s: %(levelname)s: %(message)s')

def summary(title = None):
    global API_URL
    URL = API_URL
    query_params = {
        'action': 'query',
        'prop': 'extracts',
        'explaintext': '',
        'exintro': '',
        'format': 'json',
        'titles': title
    }
    try:
        r = requests.get(URL, params=query_params)
        r.raise_for_status()
        html, r.encoding = r.text, 'gb2312'
    except:
        logger.error('error summary about ' + title)
        return ""
    text = json.loads(html, encoding='gb2312')
    id = list(text["query"]["pages"].keys())[0]
    try:
        return text["query"]["pages"][id]["extract"]
    except:
        return ""

def links(title = None):
    global API_URL
    URL = API_URL
    query_params = {
        'action': 'query',
        'prop': 'links',
        'pllimit': 'max',
        'plnamespace': '0',
        'format': 'json',
        'titles': title
    }
    try:
        r = requests.get(URL, params=query_params)
        r.raise_for_status()
        html, r.encoding = r.text, 'gb2312'
    except:
        logger.error('error links about ' + title)
        return list()
    text = json.loads(html, encoding='gb2312')
    id = list(text["query"]["pages"].keys())[0]
    link = list()
    summ = summary(title)
    try:
        for obj in text["query"]['pages'][id]["links"]:
            if obj['title'] in summ or obj['title'].lower() in summ:
                link.append(obj['title'])
    except:
        return link
    return link

if __name__ == '__main__':
    path = r"D:\NLP实验室\AL-CPL-dataset-master\data\precalculus.csv"
    with open(path, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        column = [row[1] for row in reader]
        for title in column:
            Out = links(title)
            for lin in Out:
                data = []
                data.append(lin)
                data.insert(0,title)
                with open(r"D:\NLP实验室\AL-CPL-dataset-master\相似概念对\precalculusB.csv", "a",encoding="utf-8-sig",newline="") as csvfile:
                    writer = csv.writer(csvfile)
                    writer.writerow(data)
    print("over!")

