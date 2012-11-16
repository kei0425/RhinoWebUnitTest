#coding: UTF-8

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.support.wait import WebDriverWait

driver = webdriver.Firefox()
driver.get("http://test-cross3.nikkei-r.local/develop/cross-lab/top?enq_id=906")
