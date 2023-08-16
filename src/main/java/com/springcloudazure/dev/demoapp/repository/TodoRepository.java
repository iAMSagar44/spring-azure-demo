package com.springcloudazure.dev.demoapp.repository;

import com.springcloudazure.dev.demoapp.entity.Todo;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TodoRepository extends JpaRepository<Todo, Long> {
}