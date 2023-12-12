# -*- coding:utf-8 -*-

from django.urls import path
from . import views
urlpatterns = [
    path('', views.index, name='index'), # views.py 파일에서 index 함수를 찾아!
    path('createTodo', views.createTodo, name='createTodo'), # index form 태그 action 과 연동
    path('deleteTodo/', views.deleteTodo, name='deleteTodo')
]

# my_to_do_app > urls.py