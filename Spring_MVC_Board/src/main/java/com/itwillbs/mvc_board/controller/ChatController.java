package com.itwillbs.mvc_board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ChatController {
	@GetMapping(value = "/Chat")
	public String chat() {
		return "chat/chat_view";
	}
}
