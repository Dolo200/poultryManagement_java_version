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
import java.util.Date;

/**
 *
 * @author Administrator
 */
@Entity
@Table(name = "POSTEDGOOD")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Postedgood.findAll", query = "SELECT p FROM Postedgood p"),
    @NamedQuery(name = "Postedgood.findById", query = "SELECT p FROM Postedgood p WHERE p.id = :id"),
    @NamedQuery(name = "Postedgood.findByTimePosted", query = "SELECT p FROM Postedgood p WHERE p.timePosted = :timePosted"),
    @NamedQuery(name = "Postedgood.findByUnit", query = "SELECT p FROM Postedgood p WHERE p.unit = :unit"),
    @NamedQuery(name = "Postedgood.findByPrice", query = "SELECT p FROM Postedgood p WHERE p.price = :price"),
    @NamedQuery(name = "Postedgood.findByDescription", query = "SELECT p FROM Postedgood p WHERE p.description = :description")})
public class Postedgood implements Serializable {

    private static final long serialVersionUID = 1L;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "ID")
    private BigDecimal id;
    @Column(name = "TIME_POSTED")
    @Temporal(TemporalType.TIMESTAMP)
    private Date timePosted;
    @Size(max = 50)
    @Column(name = "UNIT")
    private String unit;
    @Column(name = "PRICE")
    private BigDecimal price;
    @Size(max = 255)
    @Column(name = "DESCRIPTION")
    private String description;
    @JoinColumn(name = "PRODUCT_ID", referencedColumnName = "ID")
    @ManyToOne
    private InventoryProduct productId;

    public Postedgood() {
    }

    public Postedgood(BigDecimal id) {
        this.id = id;
    }

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public Date getTimePosted() {
        return timePosted;
    }

    public void setTimePosted(Date timePosted) {
        this.timePosted = timePosted;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public InventoryProduct getProductId() {
        return productId;
    }

    public void setProductId(InventoryProduct productId) {
        this.productId = productId;
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
        if (!(object instanceof Postedgood)) {
            return false;
        }
        Postedgood other = (Postedgood) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.Postedgood[ id=" + id + " ]";
    }
    
}
