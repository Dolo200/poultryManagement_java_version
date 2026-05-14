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
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Administrator
 */
@Entity
@Table(name = "USERS")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Users.findAll", query = "SELECT u FROM Users u"),
    @NamedQuery(name = "Users.findById", query = "SELECT u FROM Users u WHERE u.id = :id"),
    @NamedQuery(name = "Users.findByName", query = "SELECT u FROM Users u WHERE u.name = :name"),
    @NamedQuery(name = "Users.findByEmail", query = "SELECT u FROM Users u WHERE u.email = :email"),
    @NamedQuery(name = "Users.findByGender", query = "SELECT u FROM Users u WHERE u.gender = :gender"),
    @NamedQuery(name = "Users.findByTelephone", query = "SELECT u FROM Users u WHERE u.telephone = :telephone"),
    @NamedQuery(name = "Users.findByPassword", query = "SELECT u FROM Users u WHERE u.password = :password"),
    @NamedQuery(name = "Users.findByRole", query = "SELECT u FROM Users u WHERE u.role = :role")})
public class Users implements Serializable {

    private static final long serialVersionUID = 1L;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "users_seq_gen")
    @SequenceGenerator(
        name = "users_seq_gen",
        sequenceName = "users_seq",
        allocationSize = 1
    )
    @Column(name = "id")
     
    private BigDecimal id;
    @Size(max = 100)
    @Column(name = "NAME")
    private String name;
    // @Pattern(regexp="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", message="Invalid email")//if the field contains email address consider using this annotation to enforce field validation
    @Size(max = 100)
    @Column(name = "EMAIL")
    private String email;
    @Size(max = 10)
    @Column(name = "GENDER")
    private String gender;
    @Size(max = 20)
    @Column(name = "TELEPHONE")
    private String telephone;
    @Size(max = 100)
    @Column(name = "PASSWORD")
    private String password;
    @Size(max = 20)
    @Column(name = "ROLE")
    private String role;
    @Size(max = 50)
    @Column(name = "COUNTRY")
    private String country;
    @Column(name = "CREATED_AT")
    private LocalDateTime createdAt;
    @Column(name = "UPDATED_AT")
    private LocalDateTime updatedAt;
    @Size(max = 20)
    @Column(name = "STATUS")
    private String status;   // 'active' or 'blocked'

    @Size(max = 255)
    @Column(name = "PHOTO")
    private String photo;    // file path or URL to the staff photo

    @Column(name = "SALARY")
    private BigDecimal salary;

    @Column(name = "HIRE_DATE")
    @Temporal(TemporalType.DATE)
    private Date hireDate;
    @OneToMany(mappedBy = "userId")
    private List<CommunityChat> communityChatList;
    @OneToMany(mappedBy = "userId")
    private List<ChickenGroup> chickenGroupList;
    @OneToMany(mappedBy = "userId")
    private List<Alert> alertList;
    @OneToMany(mappedBy = "userId")
    private List<Report> reportList;
    @OneToMany(mappedBy = "userId")
    private List<AiChat> aiChatList;
    @OneToMany(mappedBy = "userId")
    private List<Notification> notificationList;
    @OneToMany(mappedBy = "userId")
    private List<PoultryFarm> poultryFarmList;
    @OneToMany(mappedBy = "buyerId")
    private List<Orders> ordersList;
    @OneToMany(mappedBy = "staffId")
    private List<FarmStaff> farmStaffList;
    
    public Users() {
    }

    public Users(BigDecimal id) {
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }

    public BigDecimal getSalary() { return salary; }
    public void setSalary(BigDecimal salary) { this.salary = salary; }

    public Date getHireDate() { return hireDate; }
    public void setHireDate(Date hireDate) { this.hireDate = hireDate; }
    
    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }
    
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    @XmlTransient
    public List<CommunityChat> getCommunityChatList() {
        return communityChatList;
    }

    public void setCommunityChatList(List<CommunityChat> communityChatList) {
        this.communityChatList = communityChatList;
    }

    @XmlTransient
    public List<ChickenGroup> getChickenGroupList() {
        return chickenGroupList;
    }

    public void setChickenGroupList(List<ChickenGroup> chickenGroupList) {
        this.chickenGroupList = chickenGroupList;
    }

    @XmlTransient
    public List<Alert> getAlertList() {
        return alertList;
    }

    public void setAlertList(List<Alert> alertList) {
        this.alertList = alertList;
    }

    @XmlTransient
    public List<Report> getReportList() {
        return reportList;
    }

    public void setReportList(List<Report> reportList) {
        this.reportList = reportList;
    }

    @XmlTransient
    public List<AiChat> getAiChatList() {
        return aiChatList;
    }

    public void setAiChatList(List<AiChat> aiChatList) {
        this.aiChatList = aiChatList;
    }

    @XmlTransient
    public List<Notification> getNotificationList() {
        return notificationList;
    }

    public void setNotificationList(List<Notification> notificationList) {
        this.notificationList = notificationList;
    }

    @XmlTransient
    public List<PoultryFarm> getPoultryFarmList() {
        return poultryFarmList;
    }

    public void setPoultryFarmList(List<PoultryFarm> poultryFarmList) {
        this.poultryFarmList = poultryFarmList;
    }

    @XmlTransient
    public List<Orders> getOrdersList() {
        return ordersList;
    }

    public void setOrdersList(List<Orders> ordersList) {
        this.ordersList = ordersList;
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
        if (!(object instanceof Users)) {
            return false;
        }
        Users other = (Users) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.Users[ id=" + id + " ]";
    }
    
}
