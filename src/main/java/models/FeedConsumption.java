package models;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "FEED_CONSUMPTION")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "FeedConsumption.findAll", query = "SELECT f FROM FeedConsumption f"),
    @NamedQuery(name = "FeedConsumption.findById", query = "SELECT f FROM FeedConsumption f WHERE f.id = :id"),
    @NamedQuery(name = "FeedConsumption.findByChickenGroupIds",
                query = "SELECT f FROM FeedConsumption f WHERE f.flock.id IN :ids")
})
public class FeedConsumption implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "feed_consumption_seq")
    @SequenceGenerator(name = "feed_consumption_seq", sequenceName = "feed_consumption_seq", allocationSize = 1)
    @Column(name = "ID")
    private BigDecimal id;

    @JoinColumn(name = "USER_ID", referencedColumnName = "ID")
    @ManyToOne(optional = false)
    private Users userId;

    @JoinColumn(name = "FLOCK_ID", referencedColumnName = "ID")   // references CHICKEN_GROUP
    @ManyToOne(optional = false)
    private ChickenGroup flock;

    @NotNull
    @Size(max = 100)
    @Column(name = "FEED_BATCH_ID")
    private String feedBatchId;

    @NotNull
    @Size(max = 100)
    @Column(name = "FEED_NAME")
    private String feedName;

    @NotNull
    @Column(name = "DELIVERY_DATE")
    @Temporal(TemporalType.DATE)
    private Date deliveryDate;

    @NotNull
    @Column(name = "QUANTITY_PER_DELIVERY")
    private BigDecimal quantityPerDelivery;

    @Column(name = "CRUDE_PROTEIN")
    private BigDecimal crudeProtein;

    @Column(name = "COST_PER_BAG")
    private BigDecimal costPerBag;

    @Column(name = "CUMULATIVE_FEED_KG")
    private BigDecimal cumulativeFeedKg;

    @Column(name = "CONSUMPTION_PER_DAY")
    private BigDecimal consumptionPerDay;

    @Size(max = 500)
    @Column(name = "NOTES")
    private String notes;

    public FeedConsumption() { }

    // Getters and Setters (include all fields)
    public BigDecimal getId() { return id; }
    public void setId(BigDecimal id) { this.id = id; }

    public Users getUserId() { return userId; }
    public void setUserId(Users userId) { this.userId = userId; }

    public ChickenGroup getFlock() { return flock; }
    public void setFlock(ChickenGroup flock) { this.flock = flock; }

    public String getFeedBatchId() { return feedBatchId; }
    public void setFeedBatchId(String feedBatchId) { this.feedBatchId = feedBatchId; }

    public String getFeedName() { return feedName; }
    public void setFeedName(String feedName) { this.feedName = feedName; }

    public Date getDeliveryDate() { return deliveryDate; }
    public void setDeliveryDate(Date deliveryDate) { this.deliveryDate = deliveryDate; }

    public BigDecimal getQuantityPerDelivery() { return quantityPerDelivery; }
    public void setQuantityPerDelivery(BigDecimal quantityPerDelivery) { this.quantityPerDelivery = quantityPerDelivery; }

    public BigDecimal getCrudeProtein() { return crudeProtein; }
    public void setCrudeProtein(BigDecimal crudeProtein) { this.crudeProtein = crudeProtein; }

    public BigDecimal getCostPerBag() { return costPerBag; }
    public void setCostPerBag(BigDecimal costPerBag) { this.costPerBag = costPerBag; }

    public BigDecimal getCumulativeFeedKg() { return cumulativeFeedKg; }
    public void setCumulativeFeedKg(BigDecimal cumulativeFeedKg) { this.cumulativeFeedKg = cumulativeFeedKg; }

    public BigDecimal getConsumptionPerDay() { return consumptionPerDay; }
    public void setConsumptionPerDay(BigDecimal consumptionPerDay) { this.consumptionPerDay = consumptionPerDay; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    @Override
    public int hashCode() { return id != null ? id.hashCode() : 0; }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof FeedConsumption)) return false;
        FeedConsumption other = (FeedConsumption) object;
        return (this.id == null && other.id == null) || (this.id != null && this.id.equals(other.id));
    }

    @Override
    public String toString() {
        return "models.FeedConsumption[ id=" + id + " ]";
    }
}