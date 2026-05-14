/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
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
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Administrator
 */
@Entity
@Table(name = "CHICKEN_GROUP")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "ChickenGroup.findAll", query = "SELECT c FROM ChickenGroup c"),
    @NamedQuery(name = "ChickenGroup.findById", query = "SELECT c FROM ChickenGroup c WHERE c.id = :id"),
    @NamedQuery(name = "ChickenGroup.findByName", query = "SELECT c FROM ChickenGroup c WHERE c.name = :name"),
    @NamedQuery(name = "ChickenGroup.findByType", query = "SELECT c FROM ChickenGroup c WHERE c.type = :type"),
    @NamedQuery(name = "ChickenGroup.findByQuantity", query = "SELECT c FROM ChickenGroup c WHERE c.quantity = :quantity"),
    @NamedQuery(name = "ChickenGroup.findByReceiveAge", query = "SELECT c FROM ChickenGroup c WHERE c.receiveAge = :receiveAge"),
    @NamedQuery(name = "ChickenGroup.findByCurrentAge", query = "SELECT c FROM ChickenGroup c WHERE c.currentAge = :currentAge"),
    @NamedQuery(name = "ChickenGroup.findByReceiveDate", query = "SELECT c FROM ChickenGroup c WHERE c.receiveDate = :receiveDate"),
    @NamedQuery(name = "ChickenGroup.findByOrigin", query = "SELECT c FROM ChickenGroup c WHERE c.origin = :origin"),
    @NamedQuery(name = "ChickenGroup.findByCost", query = "SELECT c FROM ChickenGroup c WHERE c.cost = :cost"),
    @NamedQuery(name = "ChickenGroup.findByFarmIds", query = "SELECT c FROM ChickenGroup c WHERE c.farmId.id IN :farmIds")})
public class ChickenGroup implements Serializable {

    private static final long serialVersionUID = 1L;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "chicken_group_seq")
    @SequenceGenerator(
    name = "chicken_group_seq",
    sequenceName = "chicken_group_seq",
    allocationSize = 1
)
    @Column(name = "ID")
    private BigDecimal id;
    @Size(max = 100)
    @Column(name = "NAME")
    private String name;
    @Size(max = 50)
    @Column(name = "TYPE")
    private String type;
    @Column(name = "QUANTITY")
    private BigInteger quantity;
    @Column(name = "RECEIVE_AGE")
    private BigInteger receiveAge;
    @Column(name = "CURRENT_AGE")
    private BigInteger currentAge;
    @Column(name = "RECEIVE_DATE")
    @Temporal(TemporalType.TIMESTAMP)
    private Date receiveDate;
    @Size(max = 100)
    @Column(name = "ORIGIN")
    private String origin;
    @Column(name = "COST")
    private BigDecimal cost;
   
    @OneToMany(mappedBy = "chickenGroupId")
private List<Mortality> mortalityList;

@OneToMany(mappedBy = "chickenGroup", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
private List<Vaccination> vaccinationList = new ArrayList<>();

// ✅ FARM relationship – must specify the join column
@ManyToOne
@JoinColumn(name = "FARM_ID", referencedColumnName = "ID")
private PoultryFarm farmId;

// ✅ USER relationship – only one @JoinColumn
@ManyToOne
@JoinColumn(name = "USER_ID", referencedColumnName = "ID")
private Users userId;

@OneToMany(mappedBy = "chickenGroupId")
private List<Report> reportList;

    public ChickenGroup() {
    }

    public ChickenGroup(BigDecimal id) {
        this.id = id;
    }

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public BigInteger getQuantity() {
        return quantity;
    }

    public void setQuantity(BigInteger quantity) {
        this.quantity = quantity;
    }

    public BigInteger getReceiveAge() {
        return receiveAge;
    }

    public void setReceiveAge(BigInteger receiveAge) {
        this.receiveAge = receiveAge;
    }

    public BigInteger getCurrentAge() {
        return currentAge;
    }

    public void setCurrentAge(BigInteger currentAge) {
        this.currentAge = currentAge;
    }

    public Date getReceiveDate() {
        return receiveDate;
    }

    public void setReceiveDate(Date receiveDate) {
        this.receiveDate = receiveDate;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public BigDecimal getCost() {
        return cost;
    }

    public void setCost(BigDecimal cost) {
        this.cost = cost;
    }

    @XmlTransient
    public List<Mortality> getMortalityList() {
        return mortalityList;
    }

    public void setMortalityList(List<Mortality> mortalityList) {
        this.mortalityList = mortalityList;
    }

    @XmlTransient
    public List<Vaccination> getVaccinationList() {
        return vaccinationList;
    }

    public void setVaccinationList(List<Vaccination> vaccinationList) {
        this.vaccinationList = vaccinationList;
    }

    public PoultryFarm getFarmId() {
        return farmId;
    }

    public void setFarmId(PoultryFarm farmId) {
        this.farmId = farmId;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
    }

    @XmlTransient
    public List<Report> getReportList() {
        return reportList;
    }

    public void setReportList(List<Report> reportList) {
        this.reportList = reportList;
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
        if (!(object instanceof ChickenGroup)) {
            return false;
        }
        ChickenGroup other = (ChickenGroup) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.ChickenGroup[ id=" + id + " ]";
    }
    
}
