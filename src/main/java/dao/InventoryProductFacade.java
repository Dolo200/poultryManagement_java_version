package dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import models.InventoryProduct;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

@Stateless
public class InventoryProductFacade extends AbstractFacade<InventoryProduct> {

    @PersistenceContext(unitName = "my_persistence_unit")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() { return em; }

    public InventoryProductFacade() { super(InventoryProduct.class); }

    public List<InventoryProduct> findByChickenGroupIds(List<BigDecimal> ids) {
        if (ids == null || ids.isEmpty()) return Collections.emptyList();
        return em.createNamedQuery("InventoryProduct.findByChickenGroupIds", InventoryProduct.class)
                 .setParameter("ids", ids)
                 .getResultList();
    }
}