package com.haui.dangkyhocphan.controller;

import com.haui.dangkyhocphan.entity.HocPhan;
import com.haui.dangkyhocphan.repository.HocPhanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/courses")
@CrossOrigin(origins = "*")
public class HocPhanController {

    @Autowired
    private HocPhanRepository repository;

    private String toUiStatus(String dbStatus) {
        if ("NGUNG_HOAT_DONG".equalsIgnoreCase(dbStatus) || "Ngừng hoạt động".equalsIgnoreCase(dbStatus)) {
            return "Ngừng hoạt động";
        }
        return "Đang hoạt động";
    }

    private String toDbStatus(String uiStatus) {
        if ("Ngừng hoạt động".equalsIgnoreCase(uiStatus) || "NGUNG_HOAT_DONG".equalsIgnoreCase(uiStatus)) {
            return "NGUNG_HOAT_DONG";
        }
        return "DANG_HOAT_DONG";
    }

    // 1. ĐỌC DỮ LIỆU: Lấy danh sách toàn bộ học phần từ SQL Server
    @GetMapping
    public List<HocPhan> getAllCourses() {
        return repository.findAll().stream().map(hp -> new HocPhan(
                hp.getCode(),
                hp.getName(),
                hp.getLt(),
                hp.getTh(),
                hp.getDesc() == null ? "" : hp.getDesc(),
                toUiStatus(hp.getStatus())
        )).collect(Collectors.toList());
    }

    // 2. GHI DỮ LIỆU: Thêm học phần mới vào SQL Server
    @PostMapping
    public ResponseEntity<?> createCourse(@RequestBody HocPhan req) {
        String code = req.getCode() != null ? req.getCode().trim().toUpperCase() : "";
        if (code.isEmpty() || req.getName() == null || req.getName().trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("message", "Mã và tên học phần không được để trống."));
        }
        if (req.getLt() + req.getTh() <= 0) {
            return ResponseEntity.badRequest().body(Map.of("message", "Tổng số tín chỉ phải lớn hơn 0."));
        }
        if (repository.existsById(code)) {
            return ResponseEntity.badRequest().body(Map.of("message", "Mã học phần đã tồn tại trong CSDL."));
        }
        HocPhan entity = new HocPhan(
                code,
                req.getName().trim(),
                req.getLt(),
                req.getTh(),
                req.getDesc(),
                toDbStatus(req.getStatus())
        );
        repository.save(entity);
        entity.setStatus(toUiStatus(entity.getStatus()));
        return ResponseEntity.ok(entity);
    }

    // 3. CẬP NHẬT DỮ LIỆU: Sửa thông tin hoặc đổi trạng thái học phần
    @PutMapping("/{code}")
    public ResponseEntity<?> updateCourse(@PathVariable String code, @RequestBody HocPhan req) {
        Optional<HocPhan> opt = repository.findById(code);
        if (opt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        if (req.getLt() + req.getTh() <= 0) {
            return ResponseEntity.badRequest().body(Map.of("message", "Tổng số tín chỉ phải lớn hơn 0."));
        }
        HocPhan entity = opt.get();
        entity.setName(req.getName().trim());
        entity.setLt(req.getLt());
        entity.setTh(req.getTh());
        entity.setDesc(req.getDesc());
        entity.setStatus(toDbStatus(req.getStatus()));
        repository.save(entity);
        entity.setStatus(toUiStatus(entity.getStatus()));
        return ResponseEntity.ok(entity);
    }

    // 4. XÓA DỮ LIỆU: Xóa học phần khỏi SQL Server
    @DeleteMapping("/{code}")
    public ResponseEntity<?> deleteCourse(@PathVariable String code) {
        if (!repository.existsById(code)) {
            return ResponseEntity.notFound().build();
        }
        try {
            repository.deleteById(code);
            return ResponseEntity.ok(Map.of("message", "Đã xóa học phần khỏi CSDL."));
        } catch (Exception ex) {
            return ResponseEntity.badRequest().body(Map.of("message", "Không thể xóa: Học phần đang có lớp học phần liên kết trong CSDL."));
        }
    }
}
