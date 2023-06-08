package kh.final_project.controllers;

import kh.final_project.dto.GalleryCard;
import kh.final_project.dto.GalleryView;
import kh.final_project.services.GalleryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/gallery")
public class GalleryController {

    private GalleryService galleryService;

    @Autowired
    public GalleryController(GalleryService galleryService) {
        this.galleryService = galleryService;
    }

    @GetMapping
    public String toGallery(Model model) {
        List<GalleryView> cards = galleryService.selectAll();
        model.addAttribute("cards", cards);
        return "/gallery/gallery";
    }

    @GetMapping("/card/{cardSeq}")
    public String toCard(@PathVariable String cardSeq, Model model) {
        
        return "/gallery/card";
    }

    @PostMapping("/card/insert")
    public String insertCard(GalleryCard card) {
        card.setWriter(10000001);
        System.out.println("card = " + card);
        galleryService.insertCard(card);
        return "redirect:/gallery";
    }

    @GetMapping("/card/insert/{categoryType}")
    public String toCardInsert(@ModelAttribute("categoryType") @PathVariable String categoryType) {
        return "/gallery/cardinsert";
    }
}
