import os
import celery
import datetime
import requests
from celery import task
from celery import Celery
from datetime import datetime
from celery.schedules import crontab
from celery.utils.log import get_task_logger

logger = get_task_logger(__name__)

# Start Celery
logger.info('Start Task')

app = Celery('Periodic', broker='pyamqp://guest@localhost//')
# Schedule
app.conf.beat_schedule = {
    'weather': {
        'task': 'weather',
        'schedule': crontab(minute='*/5')
    }
}
app.conf.timezone = 'Europe/Rome'

@task(name='weather')
def get_weather():
    logger.info('Weather Task')
    r = requests.get('https://www.metaweather.com/api/location/718345/')
    if r.status_code == 200:
        logger.info(r.json())
    else:
        logger.info(f"Error Status: {r.status_code}")
