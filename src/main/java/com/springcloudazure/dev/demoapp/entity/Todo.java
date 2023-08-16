package com.springcloudazure.dev.demoapp.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "todo")
public class Todo {

    @Id
    private Long id;

    @Column(name = "description")
    private String description;

    @Column(name = "details")
    private String details;

    @Column(name = "done", nullable = false)
    private boolean done;

    public Todo() {
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public void setDone(boolean done) {
        this.done = done;
    }

    public boolean getDone() {
        return done;
    }

    public String getDetails() {
        return details;
    }

    public String getDescription() {
        return description;
    }

}
