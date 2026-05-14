package dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import models.FeedConsumption;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

@Stateless
public class FeedConsumptionFacade extends AbstractFacade<FeedConsumption> {

    @PersistenceContext(unitName = "my_persistence_unit")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() { return em; }

    public FeedConsumptionFacade() { super(FeedConsumption.class); }

    public List<FeedConsumption> findByChickenGroupIds(List<BigDecimal> ids) {
        if (ids == null || ids.isEmpty()) return Collections.emptyList();
        return em.createNamedQuery("FeedConsumption.findByChickenGroupIds", FeedConsumption.class)
                 .setParameter("ids", ids)
                 .getResultList();
    }
}