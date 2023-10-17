package com.example.cicdDemo;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;

import java.util.Arrays;

@SpringBootApplication
public class CicdDemo {

	public static void main(String[] args) {
		SpringApplication.run(CicdDemo.class, args);
	}
	private void DoReallyNothing() {
		var counter = 100;
	}

	/**
	 * some java doc.
	 *
	 * @param ctx application contexxt
	 * @return some return
	 */
	@Bean
	public CommandLineRunner commandLineRunner(ApplicationContext ctx) {
		return args -> {
			System.out.println("Let's inspect the beans provided by Spring Boot:");

			var LongString = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Porta lorem";

			String[] beanNames = ctx.getBeanDefinitionNames();
			Arrays.sort(beanNames);
			for ( String beanName : beanNames)
			{
				System.out.println(beanName);
			}
		};
	}

}
