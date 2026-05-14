/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import jakarta.ejb.Stateless;
import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 *
 * @author Administrator
 */
@Entity
@Table(name = "FARM_STAFF")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "FarmStaff.findAll", query = "SELECT f FROM FarmStaff f"),
    @NamedQuery(name = "FarmStaff.findById", query = "SELECT f FROM FarmStaff f WHERE f.id = :id"), 
    @NamedQuery(name = "FarmStaff.findByStaffId", query = "SELECT f FROM FarmStaff f WHERE f.staffId = :staffId")
    })
public class FarmStaff implements Serializable {

    private static final long serialVersionUID = 1L;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "farm_staff_seq")
    @SequenceGenerator(
    name = "farm_staff_seq",
    sequenceName = "farm_staff_seq",
    allocationSize = 1
)

    @Column(name = "ID")
    private BigDecimal id;
    @JoinColumn(name = "FARM_ID", referencedColumnName = "ID")
    @ManyToOne(optional = false)
    private PoultryFarm farmId;
    @JoinColumn(name = "STAFF_ID", referencedColumnName = "ID")
    @ManyToOne(optional = false)
    private Users staffId;

    public FarmStaff() {
    }

    public FarmStaff(BigDecimal id) {
        this.id = id;
    }

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public PoultryFarm getFarmId() {
        return farmId;
    }

    public void setFarmId(PoultryFarm farmId) {
        this.farmId = farmId;
    }

    public Users getStaffId() {
        return staffId;
    }

    public void setStaffId(Users staffId) {
        this.staffId = staffId;
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
        if (!(object instanceof FarmStaff)) {
            return false;
        }
        FarmStaff other = (FarmStaff) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.FarmStaff[ id=" + id + " ]";
    }
    
   
    
}
