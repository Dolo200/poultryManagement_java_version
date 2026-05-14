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
import jakarta.persistence.SequenceGenerator;
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
@Table(name = "MORTALITY")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Mortality.findAll", query = "SELECT m FROM Mortality m"),
    @NamedQuery(name = "Mortality.findById", query = "SELECT m FROM Mortality m WHERE m.id = :id"),
    @NamedQuery(name = "Mortality.findByDateOfDeath", query = "SELECT m FROM Mortality m WHERE m.dateOfDeath = :dateOfDeath"),
    @NamedQuery(name = "Mortality.findByNumberOfDeath", query = "SELECT m FROM Mortality m WHERE m.numberOfDeath = :numberOfDeath"),
    @NamedQuery(name = "Mortality.findByAgeOfDeath", query = "SELECT m FROM Mortality m WHERE m.ageOfDeath = :ageOfDeath"),
    @NamedQuery(name = "Mortality.findByCause", query = "SELECT m FROM Mortality m WHERE m.cause = :cause"),
    @NamedQuery(name = "Mortality.findByLocation", query = "SELECT m FROM Mortality m WHERE m.location = :location"),
    @NamedQuery(name = "Mortality.findByActionTaken", query = "SELECT m FROM Mortality m WHERE m.actionTaken = :actionTaken"),
    @NamedQuery(name = "Mortality.findByInitialStock", query = "SELECT m FROM Mortality m WHERE m.initialStock = :initialStock"),
    @NamedQuery(name = "Mortality.findByCumulativeDeath", query = "SELECT m FROM Mortality m WHERE m.cumulativeDeath = :cumulativeDeath"),
    @NamedQuery(name = "Mortality.findByMortalityRate", query = "SELECT m FROM Mortality m WHERE m.mortalityRate = :mortalityRate"),
    @NamedQuery(name = "Mortality.findByChickenGroupIds", query = "SELECT m FROM Mortality m WHERE m.chickenGroupId.id IN :ids")})
public class Mortality implements Serializable {

    private static final long serialVersionUID = 1L;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "mortality_seq")
    @SequenceGenerator(
    name = "mortality_seq",
    sequenceName = "mortality_seq",
    allocationSize = 1
)
    @Column(name = "ID")
    private BigDecimal id;
    @Column(name = "DATE_OF_DEATH")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateOfDeath;
    @Column(name = "NUMBER_OF_DEATH")
    private BigInteger numberOfDeath;
    @Column(name = "AGE_OF_DEATH")
    private BigInteger ageOfDeath;
    @Size(max = 200)
    @Column(name = "CAUSE")
    private String cause;
    @Size(max = 100)
    @Column(name = "LOCATION")
    private String location;
    @Size(max = 200)
    @Column(name = "ACTION_TAKEN")
    private String actionTaken;
    @Column(name = "INITIAL_STOCK")
    private BigInteger initialStock;
    @Column(name = "CUMULATIVE_DEATH")
    private BigInteger cumulativeDeath;
    @Column(name = "MORTALITY_RATE")
    private BigInteger mortalityRate;
    @JoinColumn(name = "CHICKEN_GROUP_ID", referencedColumnName = "ID")
    @ManyToOne
    private ChickenGroup chickenGroupId;

    public Mortality() {
    }

    public Mortality(BigDecimal id) {
        this.id = id;
    }

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public Date getDateOfDeath() {
        return dateOfDeath;
    }

    public void setDateOfDeath(Date dateOfDeath) {
        this.dateOfDeath = dateOfDeath;
    }

    public BigInteger getNumberOfDeath() {
        return numberOfDeath;
    }

    public void setNumberOfDeath(BigInteger numberOfDeath) {
        this.numberOfDeath = numberOfDeath;
    }

    public BigInteger getAgeOfDeath() {
        return ageOfDeath;
    }

    public void setAgeOfDeath(BigInteger ageOfDeath) {
        this.ageOfDeath = ageOfDeath;
    }

    public String getCause() {
        return cause;
    }

    public void setCause(String cause) {
        this.cause = cause;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getActionTaken() {
        return actionTaken;
    }

    public void setActionTaken(String actionTaken) {
        this.actionTaken = actionTaken;
    }

    public BigInteger getInitialStock() {
        return initialStock;
    }

    public void setInitialStock(BigInteger initialStock) {
        this.initialStock = initialStock;
    }

    public BigInteger getCumulativeDeath() {
        return cumulativeDeath;
    }

    public void setCumulativeDeath(BigInteger cumulativeDeath) {
        this.cumulativeDeath = cumulativeDeath;
    }

    public BigInteger getMortalityRate() {
        return mortalityRate;
    }

    public void setMortalityRate(BigInteger mortalityRate) {
        this.mortalityRate = mortalityRate;
    }

    public ChickenGroup getChickenGroupId() {
        return chickenGroupId;
    }

    public void setChickenGroupId(ChickenGroup chickenGroupId) {
        this.chickenGroupId = chickenGroupId;
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
        if (!(object instanceof Mortality)) {
            return false;
        }
        Mortality other = (Mortality) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.Mortality[ id=" + id + " ]";
    }
    
}
