package com.haui.dangkyhocphan.repository;

import com.haui.dangkyhocphan.entity.HocPhan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface HocPhanRepository extends JpaRepository<HocPhan, String> {
}
