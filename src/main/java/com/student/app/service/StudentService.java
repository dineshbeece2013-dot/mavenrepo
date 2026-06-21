package com.student.app.service;

import com.student.app.model.Student;
import com.student.app.repository.StudentRepository;
import java.util.List;

public class StudentService {
    private StudentRepository repository = new StudentRepository();

    public void registerStudent(int id, String name, String email) {
        Student s = new Student(id, name, email);
        repository.addStudent(s);
    }

    public List<Student> getStudents() {
        return repository.getAllStudents();
    }
}