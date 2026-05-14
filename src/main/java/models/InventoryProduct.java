package models;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "INVENTORY_PRODUCT")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "InventoryProduct.findAll", query = "SELECT i FROM InventoryProduct i"),
    @NamedQuery(name = "InventoryProduct.findById", query = "SELECT i FROM InventoryProduct i WHERE i.id = :id"),
    @NamedQuery(name = "InventoryProduct.findByProductName", query = "SELECT i FROM InventoryProduct i WHERE i.productName = :productName"),
    @NamedQuery(name = "InventoryProduct.findByQuantity", query = "SELECT i FROM InventoryProduct i WHERE i.quantity = :quantity"),
    @NamedQuery(name = "InventoryProduct.findByType", query = "SELECT i FROM InventoryProduct i WHERE i.type = :type"),
    @NamedQuery(name = "InventoryProduct.findByImage", query = "SELECT i FROM InventoryProduct i WHERE i.image = :image"),
    // New query for filtering by chicken group IDs
    @NamedQuery(name = "InventoryProduct.findByChickenGroupIds",
                query = "SELECT i FROM InventoryProduct i WHERE i.chickenGroup.id IN :ids")
})
public class InventoryProduct implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "inventory_product_seq")
    @SequenceGenerator(name = "inventory_product_seq", sequenceName = "inventory_product_seq", allocationSize = 1)
    @Column(name = "ID")
    private BigDecimal id;

    @Size(max = 100)
    @Column(name = "PRODUCT_NAME")
    private String productName;

    // Old quantity column – kept for compatibility, but not used in production logic
    @Column(name = "QUANTITY")
    private BigInteger quantity;

    @Size(max = 50)
    @Column(name = "TYPE")
    private String type;

    @Size(max = 255)
    @Column(name = "IMAGE")
    private String image;

    // ---------- NEW FIELDS ----------
    @ManyToOne
    @JoinColumn(name = "CHICKEN_GROUP_ID", referencedColumnName = "ID")
    private ChickenGroup chickenGroup;

    @ManyToOne
    @JoinColumn(name = "USER_ID", referencedColumnName = "ID")
    private Users userId;

    @Column(name = "COST")
    private BigDecimal cost;

    @Column(name = "INITIAL_QUANTITY")
    private Integer initialQuantity;

    @Column(name = "AVAILABLE_QUANTITY")
    private Integer availableQuantity;

    @Size(max = 255)
    @Column(name = "DESCRIPTION")
    private String description;

    @Size(max = 100)
    @Column(name = "STORAGE_LOCATION")
    private String storageLocation;

    @Column(name = "REGISTER_DATE")
    @Temporal(TemporalType.DATE)
    private Date registerDate;

    // Existing relationship
    @OneToMany(mappedBy = "productId")
    private List<Postedgood> postedgoodList;

    public InventoryProduct() { }

    // Getters and Setters – include old ones + all new ones

    public BigDecimal getId() { return id; }
    public void setId(BigDecimal id) { this.id = id; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigInteger getQuantity() { return quantity; }
    public void setQuantity(BigInteger quantity) { this.quantity = quantity; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public ChickenGroup getChickenGroup() { return chickenGroup; }
    public void setChickenGroup(ChickenGroup chickenGroup) { this.chickenGroup = chickenGroup; }

    public Users getUserId() { return userId; }
    public void setUserId(Users userId) { this.userId = userId; }

    public BigDecimal getCost() { return cost; }
    public void setCost(BigDecimal cost) { this.cost = cost; }

    public Integer getInitialQuantity() { return initialQuantity; }
    public void setInitialQuantity(Integer initialQuantity) { this.initialQuantity = initialQuantity; }

    public Integer getAvailableQuantity() { return availableQuantity; }
    public void setAvailableQuantity(Integer availableQuantity) { this.availableQuantity = availableQuantity; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStorageLocation() { return storageLocation; }
    public void setStorageLocation(String storageLocation) { this.storageLocation = storageLocation; }

    public Date getRegisterDate() { return registerDate; }
    public void setRegisterDate(Date registerDate) { this.registerDate = registerDate; }

    @XmlTransient
    public List<Postedgood> getPostedgoodList() { return postedgoodList; }
    public void setPostedgoodList(List<Postedgood> postedgoodList) { this.postedgoodList = postedgoodList; }

    @Override
    public int hashCode() { return id != null ? id.hashCode() : 0; }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof InventoryProduct)) return false;
        InventoryProduct other = (InventoryProduct) object;
        return (this.id == null && other.id == null) || (this.id != null && this.id.equals(other.id));
    }

    @Override
    public String toString() {
        return "models.InventoryProduct[ id=" + id + " ]";
    }
}