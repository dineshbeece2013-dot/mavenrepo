package com.student.app.service;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class StudentServiceTest {

    @Test
    public void testRegisterStudent() {
        StudentService service = new StudentService();
        service.registerStudent(1, "John Doe", "john@email.com");
        
        assertEquals(1, service.getStudents().size());
        assertEquals("John Doe", service.getStudents().get(0).getName());
    }
}