/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import models.Mortality;

/**
 *
 * @author Administrator
 */
@Stateless
public class MortalityFacade extends AbstractFacade<Mortality> {

    @PersistenceContext(unitName = "my_persistence_unit")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public MortalityFacade() {
        super(Mortality.class);
    }
    
    public List<Mortality> findByChickenGroupIds(List<BigDecimal> ids) {
    if (ids == null || ids.isEmpty()) return Collections.emptyList();
    return getEntityManager()
        .createNamedQuery("Mortality.findByChickenGroupIds", Mortality.class)
        .setParameter("ids", ids)
        .getResultList();
}
    
}
