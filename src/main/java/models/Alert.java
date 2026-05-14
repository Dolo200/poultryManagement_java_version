/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;

/**
 *
 * @author Administrator
 */
@Entity
@Table(name = "ALERT")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Alert.findAll", query = "SELECT a FROM Alert a"),
    @NamedQuery(name = "Alert.findById", query = "SELECT a FROM Alert a WHERE a.id = :id"),
    @NamedQuery(name = "Alert.findByFrequency", query = "SELECT a FROM Alert a WHERE a.frequency = :frequency"),
    @NamedQuery(name = "Alert.findByDayOfWeek", query = "SELECT a FROM Alert a WHERE a.dayOfWeek = :dayOfWeek"),
    @NamedQuery(name = "Alert.findByMonth", query = "SELECT a FROM Alert a WHERE a.month = :month"),
    @NamedQuery(name = "Alert.findByYear", query = "SELECT a FROM Alert a WHERE a.year = :year"),
    @NamedQuery(name = "Alert.findByTimeOfDay", query = "SELECT a FROM Alert a WHERE a.timeOfDay = :timeOfDay"),
    @NamedQuery(name = "Alert.findByDeliveryMethod", query = "SELECT a FROM Alert a WHERE a.deliveryMethod = :deliveryMethod"),
    @NamedQuery(name = "Alert.findByScope", query = "SELECT a FROM Alert a WHERE a.scope = :scope"),
    @NamedQuery(name = "Alert.findByFarmId", query = "SELECT a FROM Alert a WHERE a.farmId = :farmId"),
    @NamedQuery(name = "Alert.findByChickenGroupId", query = "SELECT a FROM Alert a WHERE a.chickenGroupId = :chickenGroupId"),
    @NamedQuery(name = "Alert.findByCustomPrompt", query = "SELECT a FROM Alert a WHERE a.customPrompt = :customPrompt")})
public class Alert implements Serializable {

    private static final long serialVersionUID = 1L;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "ID")
    private BigDecimal id;
    @Size(max = 50)
    @Column(name = "FREQUENCY")
    private String frequency;
    @Size(max = 20)
    @Column(name = "DAY_OF_WEEK")
    private String dayOfWeek;
    @Column(name = "MONTH")
    private BigInteger month;
    @Column(name = "YEAR")
    private BigInteger year;
    @Column(name = "TIME_OF_DAY")
    @Temporal(TemporalType.TIMESTAMP)
    private Date timeOfDay;
    @Size(max = 50)
    @Column(name = "DELIVERY_METHOD")
    private String deliveryMethod;
    @Size(max = 50)
    @Column(name = "SCOPE")
    private String scope;
    @Column(name = "FARM_ID")
    private BigInteger farmId;
    @Column(name = "CHICKEN_GROUP_ID")
    private BigInteger chickenGroupId;
    @Size(max = 255)
    @Column(name = "CUSTOM_PROMPT")
    private String customPrompt;
    @JoinColumn(name = "USER_ID", referencedColumnName = "ID")
    @ManyToOne
    private Users userId;

    public Alert() {
    }

    public Alert(BigDecimal id) {
        this.id = id;
    }

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public String getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(String dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public BigInteger getMonth() {
        return month;
    }

    public void setMonth(BigInteger month) {
        this.month = month;
    }

    public BigInteger getYear() {
        return year;
    }

    public void setYear(BigInteger year) {
        this.year = year;
    }

    public Date getTimeOfDay() {
        return timeOfDay;
    }

    public void setTimeOfDay(Date timeOfDay) {
        this.timeOfDay = timeOfDay;
    }

    public String getDeliveryMethod() {
        return deliveryMethod;
    }

    public void setDeliveryMethod(String deliveryMethod) {
        this.deliveryMethod = deliveryMethod;
    }

    public String getScope() {
        return scope;
    }

    public void setScope(String scope) {
        this.scope = scope;
    }

    public BigInteger getFarmId() {
        return farmId;
    }

    public void setFarmId(BigInteger farmId) {
        this.farmId = farmId;
    }

    public BigInteger getChickenGroupId() {
        return chickenGroupId;
    }

    public void setChickenGroupId(BigInteger chickenGroupId) {
        this.chickenGroupId = chickenGroupId;
    }

    public String getCustomPrompt() {
        return customPrompt;
    }

    public void setCustomPrompt(String customPrompt) {
        this.customPrompt = customPrompt;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
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
        if (!(object instanceof Alert)) {
            return false;
        }
        Alert other = (Alert) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.Alert[ id=" + id + " ]";
    }
    
}
