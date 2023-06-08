package kh.final_project.repositories;

import kh.final_project.dto.GalleryCard;
import kh.final_project.dto.GalleryView;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class GalleryDAO {

    private SqlSessionTemplate db;

    @Autowired
    public GalleryDAO(SqlSessionTemplate db) {
        this.db = db;
    }

    public void insertCard(GalleryCard card) {
        db.insert("Gallery.insert", card);
    }

    public List<GalleryView> selectAll() {
        return db.selectList("Gallery.selectAll");
    }
}
