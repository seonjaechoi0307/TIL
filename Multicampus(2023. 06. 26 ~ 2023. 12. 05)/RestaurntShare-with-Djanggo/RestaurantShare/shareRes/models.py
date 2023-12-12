# Create your models here.
# Restaurant > shareRes > models.pt

from django.db import models

class Category(models.Model) :
    category_name  = models.CharField(max_length = 100)

class Restaurant(models.Model):
    category = models.ForeignKey(Category, on_delete = models.SET_DEFAULT, default=3)
    restaurant_name = models.CharField(max_length = 100)
    restaurant_link = models.CharField(max_length = 500)
    restaurant_content = models.TextField()
    restaurant_keyword = models.CharField(max_length = 50)
    


