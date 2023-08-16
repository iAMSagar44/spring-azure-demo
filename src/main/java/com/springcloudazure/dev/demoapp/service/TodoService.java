package com.springcloudazure.dev.demoapp.service;

import com.springcloudazure.dev.demoapp.entity.Todo;
import com.springcloudazure.dev.demoapp.repository.TodoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TodoService {
    private final TodoRepository todoRepository;

    @Autowired
    public TodoService(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    public List<Todo> retrieveTodos(){
       return todoRepository.findAll();
    }
}
