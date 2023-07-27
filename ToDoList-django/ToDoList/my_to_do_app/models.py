
from django.db import models

# Create your models here.
# ToDoList > my_to_do_app > models.py

class Todo(models.Model):
    content = models.CharField(max_length=255) #Charfiled = method

# 작성 후, 메인 페이지로 다시 돌아오기!
# 목록을 메인 페이지에 다시 보여주기
# urls.py 수정
# views.py 수정
