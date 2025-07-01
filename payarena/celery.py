from __future__ import absolute_import, unicode_literals
import os

from celery import Celery
from django.conf import settings
from celery.schedules import crontab
os.environ.setdefault('DJNAGO_SETTING_MODULE', 'payarena.settings.dev')

app=Celery('payarena')
app.conf.enable_utc = False

app.conf.update(timezone = 'Africa/Lagos')

app.config_from_object("django.conf:settings", namespace='CELERY')


# Celery Beat Schedule
app.conf.beat_schedule = {
    'monthly-loyalty-rollover': {
        'task': 'home.task.check_reward_eligibility',
        'schedule': crontab(day_of_month=1, hour=2, minute=0),  # 1st of month at 2 AM
    },

    'reset-loyalty-bonus':{
        'task': 'home.task.yearly_reset_loyalty_bonuses',
        'schedule': crontab(minute=59, hour=23, day_of_month=31, month_of_year=12)
    }
}


app.autodiscover_tasks()




@app.task(bind=True)
def debug_task(self):
    print(f'Request: {self.request!r}')
    