/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Administrator
 */
@Entity
@Table(name = "POULTRY_FARM")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "PoultryFarm.findAll", query = "SELECT p FROM PoultryFarm p"),
    @NamedQuery(name = "PoultryFarm.findById", query = "SELECT p FROM PoultryFarm p WHERE p.id = :id"),
    @NamedQuery(name = "PoultryFarm.findByFarmName", query = "SELECT p FROM PoultryFarm p WHERE p.farmName = :farmName"),
    @NamedQuery(name = "PoultryFarm.findByAddress", query = "SELECT p FROM PoultryFarm p WHERE p.address = :address"),
    @NamedQuery(name = "PoultryFarm.findByArea", query = "SELECT p FROM PoultryFarm p WHERE p.area = :area")})
public class PoultryFarm implements Serializable {

    private static final long serialVersionUID = 1L;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "poultry_farm_seq")
    @SequenceGenerator(
    name = "poultry_farm_seq",
    sequenceName = "poultry_farm_seq",
    allocationSize = 1
)
    @Column(name = "ID")
    private BigDecimal id;
    @Size(max = 100)
    @Column(name = "FARM_NAME")
    private String farmName;
    @Size(max = 200)
    @Column(name = "ADDRESS")
    private String address;
    @Column(name = "AREA")
    private BigInteger area;
    @Column(name = "PIN_COLOR")
    private String pinColor;
    @Column(name = "CREATED_AT")
    private java.util.Date createdAt;
    @OneToMany(mappedBy = "farmId")
    private List<ChickenGroup> chickenGroupList;
    @OneToMany(mappedBy = "farmId")
    private List<Report> reportList;
    @JoinColumn(name = "USER_ID", referencedColumnName = "ID")
    @ManyToOne
    private Users userId;
    @OneToMany(mappedBy = "farmId")
    private List<FarmStaff> farmStaffList;

    public PoultryFarm() {
    }

    public PoultryFarm(BigDecimal id) {
        this.id = id;
    }

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public String getFarmName() {
        return farmName;
    }

    public void setFarmName(String farmName) {
        this.farmName = farmName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public BigInteger getArea() {
        return area;
    }

    public void setArea(BigInteger area) {
        this.area = area;
    }

    @XmlTransient
    public List<ChickenGroup> getChickenGroupList() {
        return chickenGroupList;
    }

    public void setChickenGroupList(List<ChickenGroup> chickenGroupList) {
        this.chickenGroupList = chickenGroupList;
    }

    @XmlTransient
    public List<Report> getReportList() {
        return reportList;
    }

    public void setReportList(List<Report> reportList) {
        this.reportList = reportList;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
    }
    
    public String getPinColor() {
    return pinColor;
}

    public void setPinColor(String pinColor) {
    this.pinColor = pinColor;
}
    
    public Date getCreatedAt() {
    return createdAt;
}

    public void setCreatedAt(Date createdAt) {
    this.createdAt = createdAt;
}

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof PoultryFarm)) {
            return false;
        }
        PoultryFarm other = (PoultryFarm) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.PoultryFarm[ id=" + id + " ]";
    }
    
    @XmlTransient
    public List<FarmStaff> getFarmStaffList() {
        return farmStaffList;
    }

    public void setFarmStaffList(List<FarmStaff> farmStaffList) {
        this.farmStaffList = farmStaffList;
    }
}
