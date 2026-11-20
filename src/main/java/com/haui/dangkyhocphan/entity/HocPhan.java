package com.haui.dangkyhocphan.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "HOC_PHAN")
public class HocPhan {

    @Id
    @Column(name = "ma_hp", length = 20, nullable = false)
    private String code;

    @Column(name = "ten_hp", length = 150, nullable = false)
    private String name;

    @Column(name = "tc_ly_thuyet", nullable = false)
    private int lt;

    @Column(name = "tc_thuc_hanh", nullable = false)
    private int th;

    @Column(name = "mo_ta", length = 1000)
    private String desc;

    @Column(name = "trang_thai", length = 20, nullable = false)
    private String status;

    public HocPhan() {
    }

    public HocPhan(String code, String name, int lt, int th, String desc, String status) {
        this.code = code;
        this.name = name;
        this.lt = lt;
        this.th = th;
        this.desc = desc;
        this.status = status;
    }

    // Chuyển đổi trạng thái giữa DB (DANG_HOAT_DONG / NGUNG_HOAT_DONG) và giao diện tiếng Việt
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getLt() { return lt; }
    public void setLt(int lt) { this.lt = lt; }

    public int getTh() { return th; }
    public void setTh(int th) { this.th = th; }

    public String getDesc() { return desc; }
    public void setDesc(String desc) { this.desc = desc; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
