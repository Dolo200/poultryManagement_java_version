package dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import models.Vaccination;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

@Stateless
public class VaccinationFacade extends AbstractFacade<Vaccination> {

    @PersistenceContext(unitName = "my_persistence_unit")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() { return em; }

    public VaccinationFacade() { super(Vaccination.class); }

    public List<Vaccination> findByChickenGroupIds(List<BigDecimal> ids) {
        if (ids == null || ids.isEmpty()) return Collections.emptyList();
        return em.createNamedQuery("Vaccination.findByChickenGroupIds", Vaccination.class)
                 .setParameter("ids", ids)
                 .getResultList();
    }

    public List<Vaccination> findByChickenGroup(BigDecimal groupId) {
        return em.createNamedQuery("Vaccination.findByChickenGroup", Vaccination.class)
                 .setParameter("groupId", groupId)
                 .getResultList();
    }
}