package net.javaguides.springboot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

@SpringBootApplication
@RestController
public class SpringbootDockerDemoApplication {
	@GetMapping("/welcome")
	public String welcome(){
		return "Welcome to Spring Boot Docker Demo Application";
	}
	public static void main(String[] args) {
		SpringApplication.run(SpringbootDockerDemoApplication.class, args);
	}

}
