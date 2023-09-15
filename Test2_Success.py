import gurobipy as gp

m = gp.Model("ExModel")

x1 = m.addVar()
x2 = m.addVar()
x3 = m.addVar()

m.setObjective(12*x1 + 18*x2 + 22*x3, sense=gp.GRB.MAXIMIZE)

c1 = m.addConstr(1.5*x1 + 1.2*x3 <= 120)
c2 = m.addConstr(2.2*x2 + 1.4*x3 <=200)
c3 = m.addConstr(1.2*x1 + 2*x2 +2.4*x3 <= 250)

m.optimize()