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
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToOne;
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
@Table(name = "PAYMENT")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Payment.findAll", query = "SELECT p FROM Payment p"),
    @NamedQuery(name = "Payment.findById", query = "SELECT p FROM Payment p WHERE p.id = :id"),
    @NamedQuery(name = "Payment.findByTransactionId", query = "SELECT p FROM Payment p WHERE p.transactionId = :transactionId"),
    @NamedQuery(name = "Payment.findByTotalPaid", query = "SELECT p FROM Payment p WHERE p.totalPaid = :totalPaid"),
    @NamedQuery(name = "Payment.findByPaymentMethod", query = "SELECT p FROM Payment p WHERE p.paymentMethod = :paymentMethod"),
    @NamedQuery(name = "Payment.findByStripePaymentId", query = "SELECT p FROM Payment p WHERE p.stripePaymentId = :stripePaymentId"),
    @NamedQuery(name = "Payment.findByPaymentStatus", query = "SELECT p FROM Payment p WHERE p.paymentStatus = :paymentStatus"),
    @NamedQuery(name = "Payment.findByTime", query = "SELECT p FROM Payment p WHERE p.time = :time")})
public class Payment implements Serializable {

    private static final long serialVersionUID = 1L;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "ID")
    private BigDecimal id;
    @Size(max = 100)
    @Column(name = "TRANSACTION_ID")
    private String transactionId;
    @Column(name = "TOTAL_PAID")
    private BigDecimal totalPaid;
    @Size(max = 50)
    @Column(name = "PAYMENT_METHOD")
    private String paymentMethod;
    @Size(max = 100)
    @Column(name = "STRIPE_PAYMENT_ID")
    private String stripePaymentId;
    @Size(max = 50)
    @Column(name = "PAYMENT_STATUS")
    private String paymentStatus;
    @Column(name = "TIME")
    @Temporal(TemporalType.TIMESTAMP)
    private Date time;
    @JoinColumn(name = "ORDER_ID", referencedColumnName = "ID")
    @OneToOne
    private Orders orderId;

    public Payment() {
    }

    public Payment(BigDecimal id) {
        this.id = id;
    }

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public BigDecimal getTotalPaid() {
        return totalPaid;
    }

    public void setTotalPaid(BigDecimal totalPaid) {
        this.totalPaid = totalPaid;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStripePaymentId() {
        return stripePaymentId;
    }

    public void setStripePaymentId(String stripePaymentId) {
        this.stripePaymentId = stripePaymentId;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public Orders getOrderId() {
        return orderId;
    }

    public void setOrderId(Orders orderId) {
        this.orderId = orderId;
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
        if (!(object instanceof Payment)) {
            return false;
        }
        Payment other = (Payment) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.Payment[ id=" + id + " ]";
    }
    
}
