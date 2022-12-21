*-------------------------------------------------------------------------------
* Food Security and Violence project
*-------------------------------------------------------------------------------

version 12
set more off
clear all
capture log close

*****Pahts and locals
   
local data2010 C:\Users\..... /* Path for 2010 data-sets of 2010 wave of ELCA*/
local data2013 C:\Users\..... /* Path for 2013 data-sets of 2013 wave of ELCA*/
local data2016 C:\Users\..... /* Path for 2016 data-sets of 2016 wave of ELCA*/

// Graph settings(Copy this setting from the Uber project, I like the colors)

set scheme s2color

grstyle init
grstyle color background white
grstyle anglestyle vertical_tick horizontal
grstyle color major_grid dimgray
grstyle linewidth major_grid thin
grstyle yesno draw_major_hgrid yes
grstyle yesno grid_draw_min yes
grstyle yesno grid_draw_max yes
grstyle linestyle legend none
grstyle linewidth plineplot medthick


*************************************************************************************************
*1. Load Data 2010
*************************************************************************************************

**1.1 Data from comunidades 2010

cd "`data2010'"

use Rcomunidades, clear

keep ola region consecutivo_c t_hogares hambrunas vr_jornal_alim vr_jornal_sinalim seguridad /// 
     grarmados_2001 grarmados_2002 grarmados_2003 grarmados_2004 grarmados_2005 grarmados_2006 ///
	 grarmados_2007 grarmados_2008 grarmados_2009 grarmados_2010 armadoseran_2001 armadoseran_2002 ///
	 armadoseran_2003 armadoseran_2004 armadoseran_2005 armadoseran_2006 armadoseran_2007 armadoseran_2008 ///
	 armadoseran_2009 armadoseran_2010 desplaza_forzado descuido_cultivos amenazas_gra homicidios secuestros ///
	 abigeato camp_sust_ci pp_int_gra cultivos_ilicitos sometieron_gra imponen_reglas obligan_cultivosi ///
	 no_inversion_finca no_cultivos_trad quitan_ganado quitan_cosecha exigen_dinero min_ir_cabecera compras_en diligencias_en acceso sexo_lider1 sexo_lider2 sexo_lider3 sexo_lider4 sexo_lider5 sexo_lider6 ///
	 cargo_lider1 cargo_lider2 cargo_lider3 cargo_lider4 cargo_lider5 cargo_lider6 ///
	 anos_vive_lider1 anos_vive_lider2 anos_vive_lider3 anos_vive_lider4 anos_vive_lider5 anos_vive_lider6 n_lideres
	 
// Creation of the presence variables for each year

gen presence_2010= grarmados_2010==1
gen presence_acu_2010=0
replace presence_acu_2010= 1 if presence_2010==1

forvalues i=2009(-1)2001 {

gen presence_`i'= grarmados_`i'==1
gen presence_acu_`i'=0
local j = `i'+1
replace presence_acu_`i'=1 if presence_acu_`j'==1 | presence_`i'==1
}

foreach var in grarmados_2006 grarmados_2007 grarmados_2008 grarmados_2009 grarmados_2010 {

replace `var'=0 if `var'==2
}
	 
************Creation of Treatments*****************************************

foreach var in grarmados_2006 grarmados_2007 grarmados_2008 grarmados_2009 grarmados_2010 {

replace `var'=0 if `var'==2
}

 //First Treatment--Time Treatment from 2006 to 2010
    **Description: This treatment takes the value of one if at least 1 year the village has presence
 
gen treatment1= grarmados_2006==1 | grarmados_2007==1 |grarmados_2008==1 | grarmados_2009==1 | grarmados_2010==1
replace treatment1=. if grarmados_2006==. & grarmados_2007==. & grarmados_2008==. & grarmados_2009==. & grarmados_2010==.
 
	 
tempfile comunidades2010

save "`comunidades2010'", replace 

**1.2 Data from the hogar 2010

use Rhogar, clear
duplicates drop consecutivo, force

foreach var in vr_inicial_1 vr_inicial_2 vr_inicial_3 vr_inicial_4 vr_inicial_5 vr_inicial_6 vr_inicial_7 vr_inicial_8  ///
               vr_saldo_1 vr_saldo_2 vr_saldo_3 vr_saldo_4 vr_saldo_5 vr_saldo_6 vr_saldo_7 vr_saldo_8{

replace `var' = 0 if `var' == .
} 

gen debth_value = vr_inicial_1 + vr_inicial_2 + vr_inicial_3  + vr_inicial_4 + vr_inicial_5 + vr_inicial_6 + vr_inicial_7 + vr_inicial_8
gen debth_final = vr_saldo_1 + vr_saldo_2 + vr_saldo_3 + vr_saldo_4 + vr_saldo_5 + vr_saldo_6 + vr_saldo_7 + vr_saldo_8

keep consecutivo id_mpio id_depto consecutivo_c vr_gtos_mens_alim vr_gtos_mensuales riqueza_pca ///
     t_personas prg_tierras /* transp_cabec hor_cabec min_cabec */ n_neveras tit_baldios prg_tierras ///
	 familias_accion jovenes_accion sena red_juntos icbf sub_desempleo ayu_emergencias prg_adultomayor ayu_desplazados ///
	 tit_baldios prg_tierras caja_subsprest caja_saludrec agro_ingresos otro_programa tienen_deudas debth_value debth_final ///
	 con_quien_1 con_quien_2 con_quien_3 con_quien_4 con_quien_5 ayu_oi_vr ayu_ong_vr
	 
foreach var in prg_tierras /* transp_cabec hor_cabec min_cabec */  tit_baldios prg_tierras ///
	/* leydevictimas */ agro_ingresos /* oport_rural alianz_prod otro_prg_rural */ ///
	familias_accion jovenes_accion sena red_juntos icbf sub_desempleo ayu_emergencias prg_adultomayor ayu_desplazados ///
	 tit_baldios prg_tierras caja_subsprest caja_saludrec agro_ingresos otro_programa tienen_deudas {
	
replace `var' = 0 if `var'==2	
	}
	


gen support= tit_baldios==1 | prg_tierras==1 | familias_accion==1 | jovenes_accion==1 | sena==1 | ///
             red_juntos==1 | icbf==1 | sub_desempleo==1 | ayu_emergencias==1 | prg_adultomayor==1 | ayu_desplazados==1 | ///
		     tit_baldios==1 | prg_tierras==1 | caja_subsprest==1 | caja_saludrec==1 | agro_ingresos==1 | otro_programa==1
			 
	replace support= . if tit_baldios==1 & prg_tierras==1 & familias_accion==. & jovenes_accion==. & sena==. ///
	                 & red_juntos==. & icbf==. & sub_desempleo==. & ayu_emergencias==. & prg_adultomayor==. & ayu_desplazados==. & ///
		               tit_baldios==. & prg_tierras==. & caja_subsprest==. & caja_saludrec==. & agro_ingresos==. & otro_programa==.
					   
					   
gen bank       = con_quien_1==1 | con_quien_2==1 | con_quien_3==1 | con_quien_4==1 | con_quien_5 ==1
gen cooperative = con_quien_1==2 | con_quien_2==2 | con_quien_3==2 | con_quien_4==2 | con_quien_5 ==2
gen stores      = con_quien_1==3 | con_quien_2==3 | con_quien_3==3 | con_quien_4==3 | con_quien_5 ==3
gen gremio      = con_quien_1==5 | con_quien_2==5 | con_quien_3==5 | con_quien_4==5 | con_quien_5 ==5
gen family      = con_quien_1==6 | con_quien_2==6 | con_quien_3==6 | con_quien_4==6 | con_quien_5 ==6
gen friends     = con_quien_1==7 | con_quien_2==7 | con_quien_3==7 | con_quien_4==7 | con_quien_5 ==7
gen illegal_loan= con_quien_1==8 | con_quien_2==8 | con_quien_3==8 | con_quien_4==8 | con_quien_5 ==8 
gen employer    = con_quien_1==9 | con_quien_2==9 | con_quien_3==9 | con_quien_4==9 | con_quien_5 ==9
gen icetex      = con_quien_1==12 | con_quien_2==12 | con_quien_3==12 | con_quien_4==12 | con_quien_5 ==12
					   
foreach var in bank cooperative stores gremio family friends illegal_loan employer icetex {

replace `var' = 0 if `var'==.
replace `var' = . if con_quien_1==. & con_quien_2==. & con_quien_3==. & con_quien_4==. & con_quien_5 ==.

}
					   
tempfile hogar2010

save "`hogar2010'", replace 

**1.3 Data from houshold spent 2010

use Rgastos, clear 
gen count15=1 if cod_articulo<21 & per_compra<4
gen countmonth=1 if cod_articulo<21 & per_compra<5
gen co15=count15
gen com=countmonth
replace co15=1 if co15 ==. & adq_sincompra==1 & cod_articulo<21  
replace com=1 if com ==. & adq_sincompra==1 & cod_articulo<21 
gen own_buy_count15=1 if donde_obtuvo==1 & cod_articulo<21 
gen own_buy_countm=1 if donde_obtuvo==1 & cod_articulo<21 

keep ola consecutivo count15 countmonth own_buy_count15 own_buy_countm cod_articulo co15 com

tempfile articlesall2010

save "`articlesall2010'", replace

collapse (sum) count15 countmonth own_buy_count15 own_buy_countm co15 com , by(ola consecutivo)

 //Creation of percentage for food matrix
 
 gen pcount15=count15/20
 gen pcountmonth=countmonth/20
 gen pco15=co15/20
 gen pcom=com/20
 gen pown_buy_count15=own_buy_count15/co15
 gen pown_buy_countm=own_buy_countm/com

 tempfile spent2010

 save "`spent2010'", replace 
 
 //Creation of dummy variables for count 
 
 use "`articlesall2010'"
 
 keep if countmonth==1
 keep consecutivo cod_articulo countmonth 
 
 reshape wide countmonth , i(consecutivo) j(cod_articulo)
 
 forvalues i=1(1)20 {
 
 replace countmonth`i'=0 if countmonth`i'==.
 }
 
 tempfile articles2010
 save "`articles2010'", replace
 
 //Creation of dummy for self-produce
 
 use "`articlesall2010'"
 
 keep if own_buy_countm==1
 keep consecutivo cod_articulo own_buy_countm
 
 reshape wide own_buy_countm , i(consecutivo) j(cod_articulo)
 
 forvalues i=1(1)20 {
 
 replace own_buy_countm`i'=0 if own_buy_countm`i'==.
 }
 
 tempfile articlesown2010
 save "`articlesown2010'", replace
 
**1.4 Data from choques 2010

use Rchoques, clear 

keep consecutivo choque_1 choque_2 choque_3 choque_4 choque_5 choque_6 ///
     n_veces_1 n_veces_2 n_veces_3 n_veces_4 n_veces_5 n_veces_6
	 
gen lost_active = 1 if choque_1== 17 | choque_2==17 | choque_3==17 | choque_4==17 | choque_5==17 | choque_6==17  
 replace lost_active = 0 if lost_active==.

forvalues i=1/6 {
 
 gen lost_active_`i'= choque_`i'==17
 gen count_active_`i'= n_veces_`i' if choque_`i'==17
 gen total_active_`i'= lost_active_`i' * count_active_`i'
 replace total_active_`i' = 0 if total_active_`i'==.
}

gen total_active= total_active_1 + total_active_2 + total_active_3 + total_active_4 +total_active_5 + total_active_6   
gen violence_shock = 1 if choque_1== 18 | choque_2==18 | choque_3==18 | choque_4==18 | choque_5==18 | choque_6==18  
 replace violence_shock = 0 if violence_shock==.

forvalues i=1/6 {
 
 gen violence_shock_`i'= choque_`i'==18
 gen count_violence_`i'= n_veces_`i' if choque_`i'==18
 gen total_violence_`i'= violence_shock_`i' * count_violence_`i'
 replace total_violence_`i' = 0 if total_violence_`i'==.
}

gen total_violence= total_violence_1 + total_violence_2 +total_violence_3 + total_violence_4 +total_violence_5 + total_violence_6   
tempfile shock2010

save "`shock2010'", replace 

**1.5 Data from Personas 2010

use Rpersonas, clear 

replace vr_ahorro=0 if vr_ahorro==.

collapse (sum) vr_ahorro  , by(consecutivo)

tempfile personas2010

save "`personas2010'", replace
 

**1.6 Data from Land Tenure 2010

use Rtierras, clear 

keep consecutivo t_fincas tamano unidad_medida propietario tipo_tenencia precio_venta rv_ventafor permanentes permanentes_um ///
     transitorios transitorios_um mixtos mixtos_um ganaderia ganaderia_um pastos pastos_um bosques bosques_um otros_usos ///
     otros_usos_um tierra_no_usada tierra_no_usada_um inv_riego inv_estructuras inv_conservacion inv_frutales inv_maderables ///
	 inv_otros_ciales inv_vivienda inv_riego_vr inv_estructuras_vr inv_conservacion_vr inv_frutales_vr inv_maderables_vr ///
	 inv_otros_ciales_vr inv_vivienda_vr inv_otra_vr ninv_acccre ninv_proptie ninv_seguridad  ninv_faltarec 

// Adjustment for size of land

replace tamano= tamano*0.644 if unidad_medida==2
replace tamano= tamano*0.7*tamano*0.7/10000 if unidad_medida==5
replace tamano= tamano/10000 if unidad_medida==6
drop if tamano==7

foreach var in permanentes transitorios mixtos ganaderia pastos bosques otros_usos tierra_no_usada {

replace `var'= `var'*0.644 if `var'_um==2
replace `var'= `var'*0.7*`var'*0.7/10000 if `var'_um==5
replace `var'= `var'/10000 if `var'_um==6
drop if `var'==7
}

// Replace no for 0 propietario

replace propietario=0 if propietario==2
replace ninv_acccre=1 if ninv_acccre==6

replace ninv_proptie=1 if ninv_proptie==3
replace ninv_seguridad=1 if ninv_seguridad==4

foreach var in ninv_acccre ninv_proptie ninv_seguridad ninv_faltarec {
replace `var' = . if `var'==99

}

// Total Investment

foreach var in inv_riego inv_estructuras inv_conservacion inv_frutales inv_maderables ///
	 inv_otros_ciales inv_vivienda inv_riego_vr inv_estructuras_vr inv_conservacion_vr ///
	 inv_frutales_vr inv_maderables_vr inv_otros_ciales_vr inv_vivienda_vr inv_otra_vr {
	 
replace `var'= 0 if `var'==.
	 }

gen farm_inv= inv_riego + inv_estructuras + inv_conservacion + inv_frutales + inv_maderables + ///
	 inv_otros_ciales + inv_vivienda + inv_riego_vr + inv_estructuras_vr + inv_conservacion_vr + ///
	 inv_frutales_vr + inv_maderables_vr + inv_otros_ciales_vr + inv_vivienda_vr + inv_otra_vr

// Split for farm

xi i.tipo_tenencia,pre (_t) noomit

gen leasing = _ttipo_tene_6==1 | _ttipo_tene_7==1 | _ttipo_tene_8==1 | _ttipo_tene_9==1 | _ttipo_tene_11==1 | _ttipo_tene_12==1 
gen legal = _ttipo_tene_6==1 | _ttipo_tene_7==1 | _ttipo_tene_8==1 | _ttipo_tene_9==1 | _ttipo_tene_11==1 | _ttipo_tene_12==1 | propietario==1
gen ilegal = _ttipo_tene_1==1 | _ttipo_tene_2==1 | _ttipo_tene_3==1 | _ttipo_tene_4==1 | _ttipo_tene_5==1 

gen land= 1

gen size_propietario = tamano if propietario==1
replace propietario = 0 if propietario==0

gen size_leasing= tamano if leasing==1 
replace size_leasing= 0 if leasing==0

gen size_legal= tamano if legal==1 
replace size_legal= 0 if legal==0

gen size_ilegal= tamano if ilegal==1 
replace size_ilegal= 0 if ilegal==0

// Collapsing the data

collapse (sum) tamano permanentes transitorios mixtos ganaderia pastos bosques otros_usos tierra_no_usada ///
               farm_inv inv_riego inv_estructuras inv_conservacion inv_frutales inv_maderables ///
	           inv_otros_ciales inv_vivienda inv_riego_vr inv_estructuras_vr inv_conservacion_vr ///
	           inv_frutales_vr inv_maderables_vr inv_otros_ciales_vr inv_vivienda_vr inv_otra_vr /// 
			   size_propietario size_leasing size_legal size_ilegal ///
			   (max) t_fincas propietario _ttipo_tene_1 _ttipo_tene_2 _ttipo_tene_3 _ttipo_tene_4 _ttipo_tene_5 ///
			   _ttipo_tene_6 _ttipo_tene_7 _ttipo_tene_8 _ttipo_tene_9 _ttipo_tene_10 _ttipo_tene_11 _ttipo_tene_12 ///
			   land ninv_acccre ninv_proptie ninv_seguridad ninv_faltarec ///
               , by(consecutivo)  
tempfile land2010
save "`land2010'", replace 

** 1.7 Data from production

use Rproduccion

keep consecutivo jornales comprador sitio_venta t_prod_agri t_prod_pec n_cosechas periodicidad_cosechas ///
     pro_sequia pro_plagas pro_malezas pro_lluvia pro_calsem pro_vandalismo pro_otro pro_ninguno financiaron ///
	 vr_ingtotagr vr_insinsecticidas vr_insotros vr_ingtotpec vr_gastopec vr_transp periodicidad_cosechas
	 
xi i.comprador,pre (_d) noomit
xi i.financiaron, pre (_f) noomit
xi i.sitio_venta, pre (_s) noomit

rename _dcomprador_1 buy_intermediate
rename _dcomprador_2 buy_company
rename _dcomprador_3 buy_community
rename _dcomprador_4 buy_local_market
rename _dcomprador_5 buy_local_generalpeople
rename _dcomprador_6 buy_other

rename _ssitio_ven_1 place_farm
rename _ssitio_ven_2 place_village
rename _ssitio_ven_3 place_other_village
rename _ssitio_ven_4 place_district
rename _ssitio_ven_5 place_other_district
rename _ssitio_ven_6 place_other

gen m_vr_incomeagr= vr_ingtotagr + vr_ingtotpec
gen m_vr_cost_agr= vr_insinsecticidas
gen m_vr_cost_other_agr=vr_insotros
gen m_vr_cost_livestocks = vr_gastopec
gen m_vr_trans= vr_transp

foreach var in m_vr_incomeagr m_vr_cost_agr m_vr_cost_other_agr m_vr_cost_livestocks m_vr_trans {

replace `var'= `var'/ 12 if periodicidad_cosechas==1
replace `var'= `var'/ 6 if periodicidad_cosechas==2
replace `var'= `var'/ 4 if periodicidad_cosechas==3
replace `var'= `var'/ 1 if periodicidad_cosechas==4
replace `var'= .        if periodicidad_cosechas==5 | periodicidad_cosechas==9
replace `var'= 0        if `var'==.
}

collapse (sum) m_vr_incomeagr m_vr_cost_agr m_vr_cost_other_agr m_vr_cost_livestocks m_vr_trans ///
          (max) buy_intermediate buy_company buy_community buy_local_market buy_local_generalpeople buy_other ///
		       place_farm place_village place_other_village place_district place_other_district place_other , by(consecutivo)

tempfile production2010
save "`production2010'", replace 

** 1.8 Merge all data from assets 

use Ractivos_hogar, clear 

rename * asset_*
rename asset_ola ola
rename asset_consecutivo consecutivo

tempfile assets2010

save "`assets2010'", replace 
**1.5 Merge all data from 2010 data

use "`hogar2010'", clear

merge 1:1 consecutivo using "`shock2010'", nogen keep(match)
save "`hogar2010'", replace

merge 1:1 consecutivo using "`assets2010'", nogen keep(match)
save "`hogar2010'", replace

merge 1:1 consecutivo using "`spent2010'", nogen keep(match)
save "`hogar2010'", replace

merge 1:1 consecutivo using "`articles2010'",nogen keep(match)
merge 1:1 consecutivo using "`articlesown2010'",
drop _merge
merge 1:1 consecutivo using "`land2010'"
drop _merge
merge 1:1 consecutivo using "`personas2010'"
drop _merge
merge 1:1 consecutivo using "`production2010'"
merge m:1 consecutivo_c using "`comunidades2010'", nogen keep(match)

gen relevant=1
save "`hogar2010'", replace

keep consecutivo presence_* region
tempfile presence

save "`presence'", replace 

** 1.7 Create another treatment from the percentage of presence from districts 

use "`hogar2010'", clear

gen count_id_2006=1 if grarmados_2006!=.
gen count_id_2007=1 if grarmados_2007!=.
gen count_id_2008=1 if grarmados_2008!=.
gen count_id_2009=1 if grarmados_2009!=.
gen count_id_2010=1 if grarmados_2010!=.

collapse (sum) count_id_2006 count_id_2007 count_id_2008 count_id_2009 count_id_2010 grarmados_2006 grarmados_2007 grarmados_2008 grarmados_2009 grarmados_2010 (max) id_depto ///
          , by(id_mpio ola)  
		  
forvalue i=2006(1)2010 {

gen percentage_`i'= grarmados_`i'/ count_id_`i'
}

 //Second Treatment-- Spatial Treatment from 2006 to 2010
    **Description: At least one year the presence of the district was greater than 0%
 
gen treatment2= percentage_2006>0 | percentage_2007>0 | percentage_2008>0 | percentage_2009>0 | percentage_2010>0
replace treatment2=. if grarmados_2006==. | grarmados_2007==. |grarmados_2008==. | grarmados_2009==. | grarmados_2010==.

gen max_percentage = max( percentage_2006, percentage_2007, percentage_2008, percentage_2009, percentage_2010)

gen FARC_min = 0
replace FARC_min = 1 if id_depto==3
replace FARC_min = 1 if id_mpio==81

gen dif = 1 if FARC_min==1
replace dif =0 if FARC_min==0  & treatment2==1

drop max_percentage

tempfile presence2010
save "`presence2010'", replace

*************************************************************************************************
*2. Load Data 2013
*************************************************************************************************

**2.1 Data from comunidades 2013

cd "`data2013'"

use Rcomunidades, clear


keep ola consecutivo_c t_hogares hambrunas vr_jornal_alim vr_jornal_sinalim seguridad desplaza_forzado descuido_cultivos ///
	 amenazas_gra homicidios secuestros camp_sust_ci pp_int_gra cultivos_ilicitos sometieron_gra imponen_reglas ///
	 obligan_cultivosi no_inversion_finca no_cultivos_trad quitan_ganado quitan_cosecha exigen_dinero grarmados_2011 grarmados_2012 grarmados_2013 ///
	 min_ir_cabecera compras_en diligencias_en acceso 
	 
	 foreach var in grarmados_2011 grarmados_2012 grarmados_2013 {

replace `var'=0 if `var'==2
}

tempfile comunidades2013

save `comunidades2013', replace 

**2.2 Data from hogar 2013

use Rhogar, clear
duplicates drop consecutivo, force

foreach var in vr_inicial_1 vr_inicial_2 vr_inicial_3 vr_inicial_4 vr_inicial_5 vr_inicial_6 vr_inicial_7 vr_inicial_8 vr_inicial_9 vr_inicial_10 vr_inicial_11 vr_inicial_12  ///
               vr_saldo_1 vr_saldo_2 vr_saldo_3 vr_saldo_4 vr_saldo_5 vr_saldo_6 vr_saldo_7 vr_saldo_8 vr_saldo_9 vr_saldo_10 vr_saldo_11 vr_saldo_12  {

replace `var' = 0 if `var' == . 
}

gen debth_value = vr_inicial_1 + vr_inicial_2 + vr_inicial_3  + vr_inicial_4 + vr_inicial_5 + vr_inicial_6 + vr_inicial_7 + vr_inicial_8 + vr_inicial_9 + vr_inicial_10 + vr_inicial_11 + vr_inicial_12 
gen debth_final = vr_saldo_1 + vr_saldo_2 + vr_saldo_3 + vr_saldo_4 + vr_saldo_5 + vr_saldo_6 + vr_saldo_7 + vr_saldo_8 + vr_saldo_9 + vr_saldo_10 + vr_saldo_11 + vr_saldo_12 

keep llave id_mpio consecutivo ola consecutivo_c vr_gtos_mens_alim vr_gtos_mensuales riqueza_pca ///
     ing_trabagr ing_trabnoagr t_personas prg_tierras t_personas prg_tierras transp_cabec ///
	 hor_cabec min_cabec n_neveras tit_baldios leydevictimas oport_rural alianz_prod otro_prg_rural ///
	 familias_accion ayu_desastres_nat  sena red_juntos icbf prg_adultomayor ayu_desplazados ///
	 tit_baldios prg_tierras agro_ingresos otro_programa tienen_creditos debth_value debth_final ///
	 con_quien_1 con_quien_2 con_quien_3 con_quien_4 con_quien_5 con_quien_6 con_quien_7 con_quien_8 ///
	 con_quien_9 con_quien_10 con_quien_11 ayu_oi_vr ayu_ong_vr
	 
foreach var in prg_tierras tit_baldios leydevictimas oport_rural alianz_prod otro_prg_rural ///
	 familias_accion ayu_desastres_nat  sena red_juntos icbf prg_adultomayor ayu_desplazados ///
	 tit_baldios prg_tierras agro_ingresos otro_programa tienen_creditos {
	
replace `var' = 0 if `var'==2	
	}

gen support= prg_tierras==1 | tit_baldios==1| leydevictimas==1 | oport_rural==1 | alianz_prod==1 | otro_prg_rural==1 | ///
	 familias_accion==1 | ayu_desastres_nat==1 |  sena==1 | red_juntos==1 | icbf==1 | prg_adultomayor==1 | ayu_desplazados==1 | ///
	 tit_baldios==1 | prg_tierras==1  | agro_ingresos==1 | otro_programa==1
	
replace support= . if prg_tierras==. & tit_baldios==. & leydevictimas==. & oport_rural==. & alianz_prod==. & otro_prg_rural==. & ///
	 familias_accion==. & ayu_desastres_nat==. &  sena==. & red_juntos==. & icbf==. & prg_adultomayor==. & ayu_desplazados==. & ///
	 tit_baldios==. & prg_tierras==.  & agro_ingresos==1 & otro_programa==.
	 
gen bank       = con_quien_1==1 | con_quien_2==1 | con_quien_3==1 | con_quien_4==1 | con_quien_5 ==1 | con_quien_6==1 | con_quien_7==1 | con_quien_8==1 | con_quien_9==1 | con_quien_10 ==1 | con_quien_11==1
gen cooperative = con_quien_1==2 | con_quien_2==2 | con_quien_3==2 | con_quien_4==2 | con_quien_5 ==2 | con_quien_6==2 | con_quien_7==2 | con_quien_8==2 | con_quien_9==2 | con_quien_10 ==2 | con_quien_11==2
gen stores      = con_quien_1==3 | con_quien_2==3 | con_quien_3==3 | con_quien_4==3 | con_quien_5 ==3 | con_quien_6==3 | con_quien_7==3 | con_quien_8==3 | con_quien_9==3 | con_quien_10 ==3 | con_quien_11==3
gen gremio      = con_quien_1==5 | con_quien_2==5 | con_quien_3==5 | con_quien_4==5 | con_quien_5 ==5 | con_quien_6==5 | con_quien_7==5 | con_quien_8==5 | con_quien_9==5 | con_quien_10 ==5 | con_quien_11==5
gen family      = con_quien_1==6 | con_quien_2==6 | con_quien_3==6 | con_quien_4==6 | con_quien_5 ==6 | con_quien_6==6 | con_quien_7==6 | con_quien_8==6 | con_quien_9==6 | con_quien_10 ==6 | con_quien_11==6
gen friends     = con_quien_1==7 | con_quien_2==7 | con_quien_3==7 | con_quien_4==7 | con_quien_5 ==7 | con_quien_6==7 | con_quien_7==7 | con_quien_8==7 | con_quien_9==7 | con_quien_10 ==7 | con_quien_11==7
gen illegal_loan= con_quien_1==8 | con_quien_2==8 | con_quien_3==8 | con_quien_4==8 | con_quien_5 ==8 | con_quien_6==8 | con_quien_7==8 | con_quien_8==8 | con_quien_9==8 | con_quien_10 ==8 | con_quien_11==8
gen employer    = con_quien_1==9 | con_quien_2==9 | con_quien_3==9 | con_quien_4==9 | con_quien_5 ==9 | con_quien_6==9 | con_quien_7==9 | con_quien_8==9 | con_quien_9==9 | con_quien_10 ==9 | con_quien_11==9
gen icetex      = con_quien_1==11 | con_quien_2==11 | con_quien_3==11 | con_quien_4==11 | con_quien_5 ==11 | con_quien_6==11 | con_quien_7==11 | con_quien_8==11 | con_quien_9==11 | con_quien_10 ==11 | con_quien_11==11
gen small_store = con_quien_1==12 | con_quien_2==12 | con_quien_3==12 | con_quien_4==12 | con_quien_5 ==12 | con_quien_6==12 | con_quien_7==12 | con_quien_8==12 | con_quien_9==12 | con_quien_10 ==12 | con_quien_11==12

					   
foreach var in bank cooperative stores gremio family friends illegal_loan employer icetex small_store {

replace `var' = 0 if `var'==.
replace `var' = . if con_quien_1==. & con_quien_2==. & con_quien_3==. & con_quien_4==. & con_quien_5 ==.

}

	
tempfile hogar2013
save "`hogar2013'", replace 

**2.3 Data from spent 2013

use Rgastos, clear 
gen count15=1 if cod_articulo<21 & per_compra<4
gen countmonth=1 if cod_articulo<21 & per_compra<5
gen co15=count15
gen com=countmonth
replace co15=1 if co15 ==. & adq_sincompra==1 & cod_articulo<21  
replace com=1 if com ==. & adq_sincompra==1 & cod_articulo<21 
gen own_buy_count15=1 if obtuvo_finca==1 & cod_articulo<21 
gen own_buy_countm=1 if obtuvo_finca==1 & cod_articulo<21 
 

keep llave ola consecutivo count15 countmonth own_buy_count15 own_buy_countm cod_articulo co15 com

tempfile articlesall2013

save "`articlesall2013'", replace

collapse (sum) count15 countmonth own_buy_count15 own_buy_countm co15 com, by(ola consecutivo llave)

 //Creation of percentage for food matrix
 
 gen pcount15=count15/20
 gen pcountmonth=countmonth/20
 gen pco15=co15/20
 gen pcom=com/20
 gen pown_buy_count15=own_buy_count15/co15
 gen pown_buy_countm=own_buy_countm/com

 tempfile spent2013

 save "`spent2013'", replace 
 
 //Creation of dummy variables
 
 use "`articlesall2013'"
 
 keep if countmonth==1
 
 keep consecutivo cod_articulo countmonth llave
 
 duplicates drop consecutivo cod_articulo, force
 reshape wide countmonth , i(llave) j(cod_articulo)
 
 forvalues i=1(1)20 {
 replace countmonth`i'=0 if countmonth`i'==.
 }
 
 tempfile articles2013
 save "`articles2013'", replace
 
  //Creation of dummy for self-produce
 
 use "`articlesall2013'"
 
 keep if own_buy_countm==1
 keep consecutivo cod_articulo own_buy_countm llave
 
 duplicates drop consecutivo cod_articulo, force
 reshape wide own_buy_countm , i(llave) j(cod_articulo)
 
 forvalues i=1(1)20 {
 
 capture replace own_buy_countm`i'=0 if own_buy_countm`i'==.
 }
 
 tempfile articlesown2013
 save "`articlesown2013'", replace
 
 **2.4 Data from shocks 2013

use Rchoques, clear 
keep consecutivo choque tuvo_choque
	 
gen choque1= tuvo_choque==1
gen lost_active = choque1*tuvo_choque if choque== 15  
replace lost_active = 0 if lost_active==.
gen violence_shock = choque1*tuvo_choque  if choque== 17   
replace violence_shock = 0 if violence_shock==.
collapse (max) lost_active violence_shock, by(consecutivo) 

tempfile shock2013
save "`shock2013'", replace 

**2.5 Data from Personas 2013

use Rpersonas, clear 

forvalue i=1(1)6 {
xi i.ocupacion`i',pre (_`i') noomit
}

gen out_worker=_1ocupacion_1==1 | _2ocupacion_1==1 | _3ocupacion_1==1 | ///
               _1ocupacion_2==1 | _2ocupacion_2==1 | _3ocupacion_2==1 | ///
			   _1ocupacion_4==1 | _2ocupacion_4==1 | _3ocupacion_4==1 | ///
			   _1ocupacion_5==1 | _2ocupacion_5==1 | _3ocupacion_5==1
			   
replace out_worker=. if _1ocupacion_1==. & _2ocupacion_1==. & _3ocupacion_1==. & ///
               _1ocupacion_2==. & _2ocupacion_2==. & _3ocupacion_2==. & ///
			   _1ocupacion_4==. & _2ocupacion_4==. & _3ocupacion_4==. & ///
			   _1ocupacion_5==. & _2ocupacion_5==. & _3ocupacion_5==.
						
						
gen out_farm_worker=_1ocupacion_3==1 | _2ocupacion_3==1 | _3ocupacion_3==1
replace out_farm_worker=. if _1ocupacion_3==. & _2ocupacion_3==. & _3ocupacion_3==.

gen own_farm_worker=  _1ocupacion_7==1 | _2ocupacion_7==1 | _3ocupacion_7==1 ///
                    | _4ocupacion_7==1 | _5ocupacion_7==1 | _6ocupacion_7==1
					
replace own_farm_worker=. if _1ocupacion_7==. & _2ocupacion_7==. & _3ocupacion_7==. ///
                           & _4ocupacion_7==. & _5ocupacion_7==. & _6ocupacion_7==.

forvalue i=1(1)6 { 						   
gen ga_own_f_`i'=vr_ganancia`i'/meses_ganancia`i' if ocupacion`i'==7
replace ga_own_f_`i'=0 if ga_own_f_`i'==.
}

forvalue i=1(1)6 { 						   
gen ga_f_`i'=vr_ganancia`i'/meses_ganancia`i' 
replace ga_f_`i'=0 if ga_own_f_`i'==.
}

forvalue i=1(1)6 {
gen vr_salario_`i'= vr_salario`i'
}
 
egen own_f_work_benefit=rowtotal(ga_own_f_*)
replace own_f_work_benefit=. if own_farm_worker==.
egen revenue_tot=rowtotal(ga_f_*)
egen salary_tot=rowtotal(vr_salario_*)
gen mis1=1 if vr_ganancia1==. & vr_ganancia2==. & vr_ganancia3==. & vr_ganancia4==. & vr_ganancia5==. & vr_ganancia6==. 
gen mis2=1 if vr_salario1==. & vr_salario2==. & vr_salario3==. & vr_salario4==. & vr_salario5==. & vr_salario6==.


replace vr_ahorro=0 if vr_ahorro==.
replace own_f_work_benefit=0 if own_f_work_benefit==.

collapse (sum) own_f_work_benefit vr_ahorro revenue_tot salary_tot mis1 mis2 (max) out_farm_worker own_farm_worker out_worker ///
 ahorro_futuro ahorro_educ ahorro_casa ahorro_carro ahorro_otros_act ahorro_recre /// 
 ahorro_montar ahorro_mejoras ahorro_deudas ahorro_salud ahorro_emerg , by(llave)

tempfile personas2013

save "`personas2013'", replace

**2.6 Data from Land Tenure 2013

use Rtierras, clear 

keep llave consecutivo t_fincas2013 tamano unidad_medida propietario tipo_tenencia precio_venta rv_ventafor permanentes permanentes_um ///
     transitorios transitorios_um mixtos mixtos_um ganaderia ganaderia_um pastos pastos_um bosques bosques_um otros_usos ///
     otros_usos_um tierra_no_usada tierra_no_usada_um inv_riego inv_estructuras inv_conservacion inv_frutales inv_maderables ///
	 inv_otros_ciales inv_vivienda vr_inver_1 vr_inver_2 vr_inver_3 ninv_acccre ninv_proptie ninv_seguridad ninv_faltarec

// Adjustment for size of land

replace tamano= tamano*0.644 if unidad_medida==2
replace tamano= tamano/10000 if unidad_medida==3

foreach var in permanentes transitorios mixtos ganaderia pastos bosques otros_usos tierra_no_usada {

replace `var'= `var'*0.644 if `var'_um==2
replace `var'= `var'/10000 if `var'_um==3
}

// Replace no for 0 propietario

replace propietario=0 if propietario==2
replace ninv_acccre=0 if ninv_acccre==2
replace ninv_proptie=0 if ninv_proptie==2
replace ninv_seguridad=0 if ninv_seguridad==2


foreach var in ninv_acccre ninv_proptie ninv_seguridad ninv_faltarec {
replace `var' = . if `var'==99

}

rename t_fincas2013 t_fincas

// Total Investment

foreach var in vr_inver_1 vr_inver_2 vr_inver_3 {
	 
replace `var'= 0 if `var'==.
	 }

gen farm_inv= vr_inver_1 + vr_inver_2 + vr_inver_3

// Split for farm

xi i.tipo_tenencia,pre (_t) noomit


gen leasing = _ttipo_tene_6==1 | _ttipo_tene_7==1 | _ttipo_tene_8==1 | _ttipo_tene_9==1 | _ttipo_tene_11==1 | _ttipo_tene_12==1 
gen legal = _ttipo_tene_6==1 | _ttipo_tene_7==1 | _ttipo_tene_8==1 | _ttipo_tene_9==1 | _ttipo_tene_11==1 | _ttipo_tene_12==1 | propietario==1
gen ilegal = _ttipo_tene_1==1 | _ttipo_tene_2==1 | _ttipo_tene_3==1 | _ttipo_tene_4==1 | _ttipo_tene_5==1 

gen land= 1

gen size_propietario = tamano if propietario==1
replace propietario = 0 if propietario==0

gen size_leasing= tamano if leasing==1 
replace size_leasing= 0 if leasing==0

gen size_legal= tamano if legal==1 
replace size_legal= 0 if legal==0

gen size_ilegal= tamano if ilegal==1 
replace size_ilegal= 0 if ilegal==0

// Collapsing the data

collapse (sum) tamano permanentes transitorios mixtos ganaderia pastos bosques otros_usos tierra_no_usada ///
               farm_inv inv_riego inv_estructuras inv_conservacion inv_frutales inv_maderables ///
	           inv_otros_ciales inv_vivienda vr_inver_1 vr_inver_2 vr_inver_3  /// 
			   size_propietario size_leasing size_legal size_ilegal ///
			   (max) t_fincas propietario _ttipo_tene_1 _ttipo_tene_2 _ttipo_tene_3 _ttipo_tene_4 _ttipo_tene_5 ///
			   _ttipo_tene_6 _ttipo_tene_7 _ttipo_tene_8 _ttipo_tene_9 _ttipo_tene_10 _ttipo_tene_11 _ttipo_tene_12 land ///
			   ninv_acccre ninv_proptie ninv_seguridad ninv_faltarec ///
               , by(llave)  
tempfile land2013
save "`land2013'", replace 

** 2.7 Data from production 2013

use Rproduccion, clear 

keep llave consecutivo comprador sitio_venta t_prod_agri t_prod_pec n_cosechas periodicidad_cosechas ///
     pro_sequia pro_plagas pro_malezas pro_lluvia pro_calsem pro_vandalismo pro_otro pro_ninguno ///
	 prom_semilla prom_maqui prom_fertz prom_insec prom_cria prom_alim prom_vacu prom_drog ///
	 prom_vitam prom_asitec prom_manobra prom_transp prom_otrosg vr_recibe_venta period_venta
	 
xi i.comprador,pre (_d) noomit
xi i.sitio_venta, pre (_s) noomit

rename _dcomprador_1 buy_intermediate
rename _dcomprador_2 buy_company 
rename _dcomprador_3 buy_community
rename _dcomprador_4 buy_local_market
rename _dcomprador_5 buy_local_generalpeople
rename _dcomprador_6 buy_other

rename _ssitio_ven_1 place_farm
rename _ssitio_ven_2 place_village
rename _ssitio_ven_3 place_other_village
rename _ssitio_ven_4 place_district
rename _ssitio_ven_5 place_other_district
rename _ssitio_ven_6 place_other

gen m_vr_incomeagr= vr_recibe_venta 
gen m_vr_cost_agr =  prom_semilla + prom_maqui + prom_fertz + prom_insec
gen m_vr_cost_other_agr = prom_asitec + prom_manobra + prom_otrosg 
gen m_vr_cost_livestocks = prom_cria + prom_alim + prom_vacu + prom_drog + prom_vitam
gen m_vr_trans= prom_transp

foreach var in m_vr_incomeagr {

replace `var'= `var'/ 12 if period_venta==1
replace `var'= `var'/ 6 if period_venta==2
replace `var'= `var'/ 4 if period_venta==3
replace `var'= `var'/ 2 if period_venta==4
replace `var'= `var'*4  if period_venta==6
replace `var'= `var'*30  if period_venta==7
}

collapse (sum) m_vr_incomeagr m_vr_cost_agr m_vr_cost_other_agr  m_vr_cost_livestocks m_vr_trans ///
          (max) buy_intermediate buy_company buy_community buy_local_market buy_local_generalpeople buy_other ///
		       place_farm place_village place_other_village place_district place_other_district place_other , by(llave)

tempfile production2013
save "`production2013'", replace 

** 2.6 Merge all data from assets 

use Ractivos_hogar, clear 

rename * asset_*
rename asset_ola ola
rename asset_consecutivo consecutivo
rename asset_llave llave

tempfile assets2013

save "`assets2013'", replace 

**2.6 Merge 2013 data

use "`hogar2013'", clear

merge m:1 consecutivo using "`shock2013'", nogen keep(match)
merge 1:1 llave using "`assets2013'"
drop _merge
merge 1:1 llave using "`spent2013'"
drop _merge
merge 1:1 llave using "`articles2013'"
drop _merge
merge 1:1 llave using "`articlesown2013'"
drop _merge
merge 1:1 llave using "`personas2013'"
save "`hogar2013'", replace
drop _merge
merge 1:1 llave using `land2013'
drop _merge
merge 1:1 llave using `production2013'
drop _merge
merge m:1 consecutivo_c using `comunidades2013'
drop _merge

save `hogar2013', replace

*************************************************************************************************
*2. Load Data 2016
*************************************************************************************************

**2.1 Data from comunidades 2016

cd "`data2016'"

use Rcomunidades, clear

keep ola consecutivo_c t_hogares vr_jornal_alim vr_jornal_sinalim seguridad desplaza_forzado descuido_cultivos ///
	 amenazas_gra homicidios secuestros camp_sust_ci pp_int_gra cultivos_ilicitos sometieron_gra imponen_reglas ///
	 obligan_cultivosi no_inversion_finca no_cultivos_trad quitan_ganado quitan_cosecha exigen_dinero grarmados_2014 grarmados_2015 grarmados_2016 ///
	 min_ir_cabecera compras_en diligencias_en acceso

	 
foreach var in grarmados_2014 grarmados_2015 grarmados_2016 {

replace `var'=0 if `var'==2
}	 
	 
tempfile comunidades2016

save "`comunidades2016'", replace 

**2.2 Data from hogar 2016

use Rhogar, clear
duplicates drop consecutivo, force

foreach var in vr_inicial_1 vr_inicial_2 vr_inicial_3 vr_inicial_4 vr_inicial_5 vr_inicial_6 vr_inicial_7 vr_inicial_8 vr_inicial_9 ///
               vr_saldo_1 vr_saldo_2 vr_saldo_3 vr_saldo_4 vr_saldo_5 vr_saldo_6 vr_saldo_7 vr_saldo_8 vr_saldo_9 {

replace `var' = 0 if `var' == .
 }

gen debth_value = vr_inicial_1 + vr_inicial_2 + vr_inicial_3  + vr_inicial_4 + vr_inicial_5 + vr_inicial_6 + vr_inicial_7 + vr_inicial_8 + vr_inicial_9
gen debth_final = vr_saldo_1 + vr_saldo_2 + vr_saldo_3 + vr_saldo_4 + vr_saldo_5 + vr_saldo_6 + vr_saldo_7 + vr_saldo_8 + vr_saldo_9

keep llave id_mpio llave_n16 consecutivo consecutivo_c vr_gtos_mens_alim vr_gtos_mensuales riqueza_pca ///
     ing_trabagr ing_trabnoagr t_personas prg_tierras t_personas prg_tierras transp_cabec ///
	 hor_cabec min_cabec n_neveras tit_baldios leydevictimas oport_rural alianz_prod otro_prg_rural ///
	 familias_accion ayu_desastres_nat  sena red_juntos icbf prg_adultomayor ayu_desplazados ///
	 tit_baldios prg_tierras  agro_ingresos otro_programa tienen_creditos debth_value debth_final ///
	 con_quien_1 con_quien_2 con_quien_3 con_quien_4 con_quien_5 con_quien_6 con_quien_7 con_quien_8 ///
	 con_quien_9 ayu_oi_vr ayu_ong_vr
	 
foreach var in prg_tierras tit_baldios leydevictimas oport_rural alianz_prod otro_prg_rural ///
	 familias_accion ayu_desastres_nat  sena red_juntos icbf  prg_adultomayor ayu_desplazados ///
	 tit_baldios prg_tierras  agro_ingresos otro_programa  tienen_creditos  {
	
replace `var' = 0 if `var'==2	
	}
	
gen support= prg_tierras==1 | tit_baldios==1| leydevictimas==1 | oport_rural==1 | alianz_prod==1 | otro_prg_rural==1 | ///
	 familias_accion==1 | ayu_desastres_nat==1 |  sena==1 | red_juntos==1 | icbf ==1 | prg_adultomayor==1 | ayu_desplazados==1 | ///
	 tit_baldios==1 | prg_tierras==1 | agro_ingresos==1 | otro_programa==1
	
replace support= . if prg_tierras==. & tit_baldios==. & leydevictimas==. & oport_rural==. & alianz_prod==. & otro_prg_rural==. & ///
	 familias_accion==. & ayu_desastres_nat==. &  sena==. & red_juntos==. & icbf==. & prg_adultomayor==. & ayu_desplazados==. & ///
	 tit_baldios==. & prg_tierras==. & agro_ingresos==1 & otro_programa==.
	 
gen bank       = con_quien_1==1 | con_quien_2==1 | con_quien_3==1 | con_quien_4==1 | con_quien_5 ==1 | con_quien_6==1 | con_quien_7==1 | con_quien_8==1 | con_quien_9==1 
gen cooperative = con_quien_1==2 | con_quien_2==2 | con_quien_3==2 | con_quien_4==2 | con_quien_5 ==2 | con_quien_6==2 | con_quien_7==2 | con_quien_8==2 | con_quien_9==2
gen stores      = con_quien_1==3 | con_quien_2==3 | con_quien_3==3 | con_quien_4==3 | con_quien_5 ==3 | con_quien_6==3 | con_quien_7==3 | con_quien_8==3 | con_quien_9==3
gen gremio      = con_quien_1==5 | con_quien_2==5 | con_quien_3==5 | con_quien_4==5 | con_quien_5 ==5 | con_quien_6==5 | con_quien_7==5 | con_quien_8==5 | con_quien_9==5
gen family      = con_quien_1==6 | con_quien_2==6 | con_quien_3==6 | con_quien_4==6 | con_quien_5 ==6 | con_quien_6==6 | con_quien_7==6 | con_quien_8==6 | con_quien_9==6
gen friends     = con_quien_1==7 | con_quien_2==7 | con_quien_3==7 | con_quien_4==7 | con_quien_5 ==7 | con_quien_6==7 | con_quien_7==7 | con_quien_8==7 | con_quien_9==7
gen illegal_loan= con_quien_1==8 | con_quien_2==8 | con_quien_3==8 | con_quien_4==8 | con_quien_5 ==8 | con_quien_6==8 | con_quien_7==8 | con_quien_8==8 | con_quien_9==8
gen employer    = con_quien_1==9 | con_quien_2==9 | con_quien_3==9 | con_quien_4==9 | con_quien_5 ==9 | con_quien_6==9 | con_quien_7==9 | con_quien_8==9 | con_quien_9==9
gen icetex      = con_quien_1==11 | con_quien_2==11 | con_quien_3==11 | con_quien_4==11 | con_quien_5 ==11 | con_quien_6==11 | con_quien_7==11 | con_quien_8==11 | con_quien_9==11 
gen small_store = con_quien_1==12 | con_quien_2==12 | con_quien_3==12 | con_quien_4==12 | con_quien_5 ==12 | con_quien_6==12 | con_quien_7==12 | con_quien_8==12 | con_quien_9==12 

					   
foreach var in bank cooperative stores gremio family friends illegal_loan employer icetex small_store {

replace `var' = 0 if `var'==.
replace `var' = . if con_quien_1==. & con_quien_2==. & con_quien_3==. & con_quien_4==. & con_quien_5 ==.

}

	 
tempfile hogar2016
save "`hogar2016'", replace 


**2.3 Data from spent 2016

use Rgastos, clear 
gen count15=1 if cod_articulo<21 & per_compra<4
gen countmonth=1 if cod_articulo<21 & per_compra<5
gen co15=count15
gen com=countmonth
replace co15=1 if co15 ==. & adq_sincompra==1 & cod_articulo<21  
replace com=1 if com ==. & adq_sincompra==1 & cod_articulo<21 
gen own_buy_count15=1 if obtuvo_finca==1 & cod_articulo<21 
gen own_buy_countm=1 if obtuvo_finca==1 & cod_articulo<21 
 

keep llave llave_n16 ola consecutivo count15 countmonth own_buy_count15 own_buy_countm  cod_articulo co15 com

tempfile articlesall2016

save "`articlesall2016'", replace

collapse (sum) count15 countmonth own_buy_count15 own_buy_countm co15 com (max) llave , by(ola consecutivo llave_n16)

 //Creation of percentage for food matrix
 
 gen pcount15=count15/20
 gen pcountmonth=countmonth/20
 gen pco15=co15/20
 gen pcom=com/20
 gen pown_buy_count15=own_buy_count15/co15
 gen pown_buy_countm=own_buy_countm/com

 tempfile spent2016

 save "`spent2016'", replace 
 
 //Creation of dummy variables
 
 use "`articlesall2016'"
 
 keep if countmonth==1
 
 keep consecutivo cod_articulo countmonth llave llave_n16
 duplicates drop consecutivo cod_articulo, force

 reshape wide countmonth , i(llave_n16) j(cod_articulo)
 
 forvalues i=1(1)20 {
 
 replace countmonth`i'=0 if countmonth`i'==.
 }
 
 tempfile articles2016
 save "`articles2016'", replace
 
 //Creation of dummy for self-produce
 
 use "`articlesall2016'"
 
 keep if own_buy_countm==1
 
 keep consecutivo cod_articulo own_buy_countm llave llave_n16
 duplicates drop consecutivo cod_articulo, force
 
 reshape wide own_buy_countm , i(llave_n16) j(cod_articulo)
 
 forvalues i=1(1)20 {
 
 capture replace own_buy_countm`i'=0 if own_buy_countm`i'==.
 }
 
 tempfile articlesown2016
 save "`articlesown2016'", replace
 
**2.4 Data from shocks 2016

use Rchoques, clear 
keep consecutivo choque tuvo_choque
gen choque1= tuvo_choque==1

gen lost_active = choque1*tuvo_choque if choque== 15  
replace lost_active = 0 if lost_active==.
gen violence_shock = choque1*tuvo_choque  if choque== 19   
replace violence_shock = 0 if violence_shock==.

collapse (max) lost_active violence_shock, by(consecutivo) 
tempfile shock2016
save "`shock2016'", replace 

**2.5 Data from Personas 2016

use Rpersonas, clear 

forvalue i=1(1)5 {
xi i.ocupacion`i',pre (_`i') noomit
}

gen out_worker=_1ocupacion_1==1 | _2ocupacion_1==1 | ///
               _1ocupacion_2==1 | _2ocupacion_2==1 | ///
			   _1ocupacion_4==1 | _2ocupacion_4==1 | _3ocupacion_4==1 | ///
			   _1ocupacion_5==1 | _2ocupacion_5==1 | _3ocupacion_5==1 
			   
			   
replace out_worker=. if _1ocupacion_1==. & _2ocupacion_1==. & ///
               _1ocupacion_2==. & _2ocupacion_2==. & ///
			   _1ocupacion_4==. & _2ocupacion_4==. & _3ocupacion_4==. & ///
			   _1ocupacion_5==. & _2ocupacion_5==. & _3ocupacion_5==.  

gen out_farm_worker=_1ocupacion_3==1 | _2ocupacion_3==1 | _3ocupacion_3==1
replace out_farm_worker=. if _1ocupacion_3==. & _2ocupacion_3==. & _3ocupacion_3==.

gen own_farm_worker=  _1ocupacion_7==1 | _2ocupacion_7==1 | _3ocupacion_7==1 ///
                    | _4ocupacion_7==1 | _5ocupacion_7==1 
					
replace own_farm_worker=. if _1ocupacion_7==. & _2ocupacion_7==. & _3ocupacion_7==. ///
                           & _4ocupacion_7==. & _5ocupacion_7==. 

forvalue i=1(1)5 { 						   
gen ga_own_f_`i'=vr_ganancia`i'/meses_ganancia`i' if ocupacion`i'==7
replace ga_own_f_`i'=0 if ga_own_f_`i'==.
}

forvalue i=1(1)5 { 						   
gen ga_f_`i'=vr_ganancia`i'/meses_ganancia`i' 
replace ga_f_`i'=0 if ga_own_f_`i'==.
}

forvalue i=1(1)5 {
gen vr_salario_`i'= vr_salario`i'
}
 
egen own_f_work_benefit=rowtotal(ga_own_f_*)
replace own_f_work_benefit=. if own_farm_worker==.
egen revenue_tot=rowtotal(ga_f_*)
egen salary_tot=rowtotal(vr_salario_*)
gen mis1=1 if vr_ganancia1==. & vr_ganancia2==. & vr_ganancia3==. & vr_ganancia4==. & vr_ganancia5==. 
gen mis2=1 if vr_salario1==. & vr_salario2==. & vr_salario3==. & vr_salario4==. & vr_salario5==. 


replace vr_ahorro=0 if vr_ahorro==.
replace own_f_work_benefit=0 if own_f_work_benefit==.

collapse (sum) own_f_work_benefit vr_ahorro revenue_tot salary_tot mis1 mis2 (max) out_farm_worker own_farm_worker out_worker ///
 ahorro_futuro ahorro_educ ahorro_casa ahorro_carro ahorro_otros_act ahorro_recre /// 
 ahorro_montar ahorro_mejoras ahorro_deudas ahorro_salud ahorro_emerg firma_paz , by(llave_n16)

tempfile personas2016

save "`personas2016'", replace

**3.6 Data from Land Tenure 2016

use Rtierras, clear 

keep llave llave_n16 consecutivo t_fincas2016 tamano unidad_medida propietario tipo_tenencia precio_venta rv_ventafor permanentes permanentes_um ///
     transitorios transitorios_um mixtos mixtos_um ganaderia ganaderia_um pastos pastos_um bosques bosques_um otros_usos ///
     otros_usos_um tierra_no_usada tierra_no_usada_um inv_riego inv_estructuras inv_conservacion inv_frutales inv_maderables ///
	 inv_otros_ciales inv_vivienda vr_inver_1 vr_inver_2 vr_inver_3 ninv_acccre ninv_proptie ninv_seguridad ninv_faltarec

// Adjustment for size of land

replace tamano= tamano*0.644 if unidad_medida==2
replace tamano= tamano/10000 if unidad_medida==3

foreach var in permanentes transitorios mixtos ganaderia pastos bosques otros_usos tierra_no_usada {

replace `var'= `var'*0.644 if `var'_um==2
replace `var'= `var'/10000 if `var'_um==3
}

// Replace no for 0 propietario

replace propietario=0 if propietario==2
replace ninv_acccre=0 if ninv_acccre==2
replace ninv_proptie=0 if ninv_proptie==2
replace ninv_seguridad=0 if ninv_seguridad==2

rename t_fincas2016 t_fincas

// Total Investment

foreach var in vr_inver_1 vr_inver_2 vr_inver_3 {
	 
replace `var'= 0 if `var'==.
	 }

gen farm_inv= vr_inver_1 + vr_inver_2 + vr_inver_3

// Split for farm

xi i.tipo_tenencia,pre (_t) noomit

gen leasing = _ttipo_tene_6==1 | _ttipo_tene_7==1 | _ttipo_tene_8==1 | _ttipo_tene_9==1 | _ttipo_tene_11==1 | _ttipo_tene_12==1 
gen legal = _ttipo_tene_6==1 | _ttipo_tene_7==1 | _ttipo_tene_8==1 | _ttipo_tene_9==1 | _ttipo_tene_11==1 | _ttipo_tene_12==1 | propietario==1
gen ilegal = _ttipo_tene_1==1 | _ttipo_tene_2==1 | _ttipo_tene_3==1 | _ttipo_tene_4==1 | _ttipo_tene_5==1 

gen land= 1

gen size_propietario = tamano if propietario==1
replace propietario = 0 if propietario==0

gen size_leasing= tamano if leasing==1 
replace size_leasing= 0 if leasing==0

gen size_legal= tamano if legal==1 
replace size_legal= 0 if legal==0

gen size_ilegal= tamano if ilegal==1 
replace size_ilegal= 0 if ilegal==0

// Collapsing the data

collapse (sum) tamano permanentes transitorios mixtos ganaderia pastos bosques otros_usos tierra_no_usada ///
               farm_inv inv_riego inv_estructuras inv_conservacion inv_frutales inv_maderables ///
	           inv_otros_ciales inv_vivienda vr_inver_1 vr_inver_2 vr_inver_3  /// 
			   size_propietario size_leasing size_legal size_ilegal ///
			   (max) t_fincas propietario _ttipo_tene_1 _ttipo_tene_2 _ttipo_tene_3 _ttipo_tene_4 _ttipo_tene_5 ///
			   _ttipo_tene_6 _ttipo_tene_7 _ttipo_tene_8 _ttipo_tene_9  _ttipo_tene_11 _ttipo_tene_12 consecutivo land ///
                ninv_acccre ninv_proptie ninv_seguridad ninv_faltarec , by(llave_n16)  
			   
tempfile land2016
save "`land2016'", replace 

** 3.7 Data from production 2016

use Rproduccion, clear 

keep llave llave_n16 consecutivo comprador sitio_venta t_prod_agri t_prod_pec n_cosechas periodicidad ///
     pro_sequia pro_plagas pro_malezas pro_lluvia pro_calsem pro_vandalismo pro_otro pro_ninguno ///
	 prom_semilla prom_maqui prom_fertz prom_insec prom_cria prom_alim prom_vacu prom_drog ///
	 prom_vitam prom_asitec prom_manobra prom_transp prom_otrosg vr_recibe_venta period_venta
	 
xi i.comprador,pre (_d) noomit
xi i.sitio_venta, pre (_s) noomit

rename _dcomprador_1 buy_intermediate
rename _dcomprador_2 buy_company
rename _dcomprador_3 buy_community
rename _dcomprador_4 buy_local_market
rename _dcomprador_5 buy_local_generalpeople
rename _dcomprador_6 buy_other

rename _ssitio_ven_1 place_farm
rename _ssitio_ven_2 place_village
rename _ssitio_ven_3 place_other_village
rename _ssitio_ven_4 place_district
rename _ssitio_ven_5 place_other_district
rename _ssitio_ven_6 place_other

gen m_vr_incomeagr= vr_recibe_venta 
gen m_vr_cost_agr =  prom_semilla + prom_maqui + prom_fertz + prom_insec
gen m_vr_cost_other_agr = prom_asitec + prom_manobra + prom_otrosg 
gen m_vr_cost_livestocks = prom_cria + prom_alim + prom_vacu + prom_drog + prom_vitam
gen m_vr_trans= prom_transp

foreach var in m_vr_incomeagr {

replace `var'= `var'/ 12 if period_venta==1
replace `var'= `var'/ 6 if period_venta==2
replace `var'= `var'/ 4 if period_venta==3
replace `var'= `var'/ 2 if period_venta==4
replace `var'= `var'*4  if period_venta==6
replace `var'= `var'*30 if period_venta==7
}

collapse (sum) m_vr_incomeagr m_vr_cost_agr m_vr_cost_other_agr  m_vr_cost_livestocks m_vr_trans ///
          (max) buy_intermediate buy_company buy_community buy_local_market buy_local_generalpeople buy_other ///
		       place_farm place_village place_other_village place_district place_other_district place_other , by(llave_n16)

tempfile production2016
save "`production2016'", replace 

** 2.6 Merge all data from assets 

use Ractivos_hogar, clear 

rename * asset_*
rename asset_ola ola
rename asset_consecutivo consecutivo
rename asset_llave llave
rename asset_llave_n16 llave_n16

tempfile assets2016

save "`assets2016'", replace 

**2.7 Merge 2016 data

use "`hogar2016'", clear

merge m:1 consecutivo using "`shock2016'", nogen keep(match)
save "`hogar2016'", replace

merge 1:1 llave_n16 using "`assets2016'"
save "`hogar2016'", replace
drop _merge
merge 1:1 llave_n16 using "`spent2016'"
drop _merge
merge 1:1 llave_n16 using "`articles2016'"
drop _merge
merge 1:1 llave_n16 using "`articlesown2016'"
drop _merge

merge 1:1 llave_n16 using "`personas2016'"
drop _merge

merge 1:1 llave_n16 using "`land2016'"
drop _merge
merge 1:1 llave_n16 using "`production2016'"
drop _merge
merge m:1 consecutivo_c using "`comunidades2016'"

drop _merge

save "`hogar2016'", replace

*************Append all the data*************************************************+

use "`hogar2010'", clear

append using "`hogar2013'"
tempfile data_set

save "`data_set'", replace
use "`hogar2016'", clear

append using "`data_set'"
save "`data_set'", replace

***********Merge the presence data from 2010*************************************

merge m:1 consecutivo using "`presence'", nogen keep(match)

set seed 123

bysort consecutivo_c(treatment1): replace treatment1 = treatment1[1]
bysort consecutivo_c(relevant): replace relevant = relevant[1]
bysort consecutivo(region): replace region = region[1]
bysort consecutivo(desplaza_forzado): replace desplaza_forzado = desplaza_forzado[1]
bysort consecutivo(descuido_cultivos): replace descuido_cultivos = descuido_cultivos[1]
bysort consecutivo(amenazas_gra): replace amenazas_gra = amenazas_gra[1]

gen share = vr_gtos_mens_alim / vr_gtos_mensuales * 100
replace share = . if share>100

************Change some variables**************************************************

foreach var in desplaza_forzado descuido_cultivos camp_sust_ci pp_int_gra cultivos_ilicitos sometieron_gra ///
imponen_reglas obligan_cultivosi no_cultivos_trad no_inversion_finca {

replace `var' = 1 if `var'==1 
replace `var' = 0 if `var'==2
}

gen amenazas_gra_d= 1 if amenazas_gra==2
replace amenazas_gra_d=0 if amenazas_gra==1

foreach var in homicidios secuestros  {

gen `var'_d=1 if `var'==1 & ola==1
replace `var'_d=0 if `var'==2 & ola==1
replace `var'_d=1 if `var'>1 & ola>1
replace `var'_d=0 if `var'==1 & ola>1
}
areg pcountmonth treatment1, a(consecutivo)

**************Merge data for percentage of presence 2010*************************

merge m:1 id_mpio using "`presence2010'", nogen keep(match)

bysort consecutivo_c(treatment2): replace treatment2 = treatment2[1]	
bysort consecutivo_c(id_depto): replace id_depto = id_depto[1]		   			   
save "`data_set'", replace

**********Labels******************************************************************
***Descriptive Analysis 

use "`data_set'", clear

label variable lost_active                       "Lost active"
label variable violence_shock                    "Victims of violence"
label variable seguridad                         "Unsafety perception"
label variable vr_gtos_mensuales                 "Total spend(month)"
label variable vr_gtos_mens_alim                 "Food spend(month)"
label variable riqueza_pca                       "Wealth measure(Actives)"
label variable vr_jornal_alim                    "Agricultural salary"
label variable vr_jornal_sinalim                 "Agricultural salary(No food)"
label variable share                             "Share of Food"
label variable desplaza_forzado                  "Forced movement"
label variable descuido                          "Bad management"
label variable amenazas_gra                      "Threatens"
label variable homicidios                        "Murders"
label variable secuestros                        "Kidnapings"
	   			   
****************Creation of Variables for Regression****************************************

xtset consecutivo ola 

//First variables

gen assets = riqueza_pca
replace assets=assets+3.596233
tabulate ola, generate(ola_t)
gen assets_0=assets if ola_t1==1
bysort consecutivo: egen a= max(assets_0)

drop assets_0
rename a assets_0

gen assets_1=assets if ola_t2==1
bysort consecutivo: egen a= max(assets_1)
drop assets_1
rename a assets_1

//Creation of log variables and tenure

gen ln_gastos_t =ln(vr_gtos_mensuales)
gen ln_gastos_a =ln(vr_gtos_mens_alim)
gen ln_ing_agr =ln(ing_trabagr)
gen ln_ing_noagre =ln(ing_trabnoagr)

gen tenure=tamano>0
replace tenure =0 if tamano==.
gen illegal_tenure=  _ttipo_tene_1==1 | _ttipo_tene_2==1 | _ttipo_tene_3==1 | _ttipo_tene_4==1 | _ttipo_tene_5==1
replace illegal_tenure =0 if tenure==0

gen tenure2= propietario==1 
replace tenure2=1 if _ttipo_tene_6==1 | _ttipo_tene_7==1 | _ttipo_tene_8==1 | _ttipo_tene_9==1 | _ttipo_tene_10==1 | _ttipo_tene_11==1 | _ttipo_tene_12==1
replace tenure2=0 if tenure==0 

// Change Access variables

gen same_district_buy = compras_en==1
replace same_district_buy=. if compras_en==.

gen same_other_district_buy = compras_en==2
replace same_other_district_buy=. if compras_en==.

gen good_transp_infra= acceso==2 | acceso==4
replace good_transp_infra=. if good_transp_infra==.

gen very_bad_infra= acceso==5| acceso==6 | acceso==7
replace very_bad_infra=. if very_bad_infra==.

//Creation of variables of assets in the initial period//

rename lost_active l_active 

foreach  a in  asset_n_tiro_animal asset_n_tractor asset_n_otros_tractor asset_n_cosechadora asset_n_sembradora ///
            asset_n_guadanadora asset_n_motosierra asset_n_bomba_agua asset_n_camion asset_n_fumiga_motor asset_n_fumiga_espalda ///
			asset_n_planta_elec asset_n_planta_gas asset_n_equip_riego asset_n_ordenadora asset_n_trapiche asset_n_molino_arroz ///
			asset_n_beneficiadero asset_n_establo asset_n_invernadero asset_n_corral asset_n_abrevadero asset_n_bodega asset_n_otro_activo ///
			asset_n_silos asset_n_bueyes asset_n_caballos_carga asset_n_vacas asset_n_cerdos asset_n_avescorral asset_n_peces asset_n_caballos ///
			asset_n_ovejas asset_n_abejas camp_sust_ci pp_int_gra cultivos_ilicitos sometieron_gra imponen_reglas obligan_cultivosi no_cultivos_trad no_inversion_finca ///
			quitan_ganado quitan_cosecha exigen_dinero ln_gastos_t riqueza_pca t_personas tamano propietario tenure tenure2 illegal_tenure support ///
			same_district_buy same_other_district_buy good_transp_infra very_bad_infra min_ir_cabecera tit_baldios prg_tierras leydevictimas agro_ingresos oport_rural alianz_prod otro_prg_rural seguridad l_active vr_ahorro ///
			ayu_oi_vr ayu_ong_vr {
			
gen `a'_0 = `a' if ola_t1==1
bysort consecutivo: egen a= max(`a'_0)

drop `a'_0
rename a `a'_0

gen `a'_1 = `a' if ola_t2==1
bysort consecutivo: egen a= max(`a'_1)

drop `a'_1
rename a `a'_1		
			
	}
			
replace imponen_reglas=1 if imponen_reglas==4

//Creation of intensity variable

gen years_presence= presence_2006 + presence_2007 + presence_2008 + presence_2009 + presence_2009 + presence_2010
gen long_years_presence= presence_2002 + presence_2003 + presence_2004 + presence_2005 + presence_2006 + presence_2007 + presence_2008 + presence_2009 + presence_2009 + presence_2010

bysort consecutivo_c(years_presence): replace years_presence = years_presence[1]
bysort consecutivo_c(long_years_presence): replace long_years_presence = long_years_presence[1]

//Creation of all the treatment variables 
   ***Treatment3 (neighbords od treatment1)
   
gen treatment3= treatment2
replace treatment3=0 if treatment1==1

foreach var in  treatment1 treatment2 treatment3 {

gen `var'_t1= `var' * ola_t1
gen `var'_t2= `var' * ola_t2
gen `var'_t3= `var' * ola_t3
}

//Creation of combinations of all assets with dummy variables

foreach  a in asset_n_tiro_animal asset_n_tractor asset_n_otros_tractor asset_n_cosechadora asset_n_sembradora ///
            asset_n_guadanadora asset_n_motosierra asset_n_bomba_agua asset_n_camion asset_n_fumiga_motor asset_n_fumiga_espalda ///
			asset_n_planta_elec asset_n_planta_gas asset_n_equip_riego asset_n_ordenadora asset_n_trapiche asset_n_molino_arroz ///
			asset_n_beneficiadero asset_n_establo asset_n_invernadero asset_n_corral asset_n_abrevadero asset_n_bodega asset_n_otro_activo ///
			asset_n_silos asset_n_bueyes asset_n_caballos_carga asset_n_vacas asset_n_cerdos asset_n_avescorral asset_n_peces asset_n_caballos ///
			asset_n_ovejas asset_n_abejas vr_ahorro {
			
	replace	`a'_0=0 if `a'_0==.	
	replace	`a'_1=0 if `a'_1==.
			}
			
//Creation of combinations of treatment and assets 

foreach  a in  asset_n_tiro_animal_0 asset_n_tractor_0 asset_n_otros_tractor_0 asset_n_cosechadora_0 asset_n_sembradora_0 ///
            asset_n_guadanadora_0 asset_n_motosierra_0 asset_n_bomba_agua_0 asset_n_camion_0 asset_n_fumiga_motor_0 asset_n_fumiga_espalda_0 ///
			asset_n_planta_elec_0 asset_n_planta_gas_0 asset_n_equip_riego_0 asset_n_ordenadora_0 asset_n_trapiche_0 asset_n_molino_arroz_0 ///
			asset_n_beneficiadero_0 asset_n_establo_0 asset_n_invernadero_0 asset_n_corral_0 asset_n_abrevadero_0 asset_n_bodega_0 asset_n_otro_activo_0 ///
			asset_n_silos_0 asset_n_bueyes_0 asset_n_caballos_carga_0 asset_n_vacas_0 asset_n_cerdos_0 asset_n_avescorral_0 asset_n_peces_0 asset_n_caballos_0 ///
			asset_n_ovejas_0 asset_n_abejas_0 assets_0 years_presence ln_gastos_t_0 riqueza_pca_0 t_personas_0 tamano_0 propietario_0 {
			
gen `a'_t1= `a' * ola_t1
gen `a'_t2= `a' * ola_t2
gen `a'_t3= `a' * ola_t3

foreach var in treatment {

gen `a'_T1_t1= `a' * `var'1_t1
gen `a'_T1_t2= `a' * `var'1_t2
gen `a'_T1_t3= `a' * `var'1_t3
gen `a'_T1= `a' * `var'1

gen `a'_T2_t1= `a' * `var'2_t1
gen `a'_T2_t2= `a' * `var'2_t2
gen `a'_T2_t3= `a' * `var'2_t3
gen `a'_T2= `a' * `var'2
}
}

foreach  a in  asset_n_tiro_animal_1 asset_n_tractor_1 asset_n_otros_tractor_1 asset_n_cosechadora_1 asset_n_sembradora_1 ///
            asset_n_guadanadora_1 asset_n_motosierra_1 asset_n_bomba_agua_1 asset_n_camion_1 asset_n_fumiga_motor_1 asset_n_fumiga_espalda_1 ///
			asset_n_planta_elec_1 asset_n_planta_gas_1 asset_n_equip_riego_1 asset_n_ordenadora_1 asset_n_trapiche_1 asset_n_molino_arroz_1 ///
			asset_n_beneficiadero_1 asset_n_establo_1 asset_n_invernadero_1 asset_n_corral_1 asset_n_abrevadero_1 asset_n_bodega_1 asset_n_otro_activo_1 ///
			asset_n_silos_1 asset_n_bueyes_1 asset_n_caballos_carga_1 asset_n_vacas_1 asset_n_cerdos_1 asset_n_avescorral_1 asset_n_peces_1 asset_n_caballos_1 ///
			asset_n_ovejas_1 asset_n_abejas_1 assets_1 ln_gastos_t_1 riqueza_pca_1 t_personas_1 {
			
gen `a'_t1= `a' * ola_t1
gen `a'_t2= `a' * ola_t2
gen `a'_t3= `a' * ola_t3

foreach var in treatment {

gen `a'_T1_t1= `a' * `var'1_t1
gen `a'_T1_t2= `a' * `var'1_t2
gen `a'_T1_t3= `a' * `var'1_t3
gen `a'_T1= `a' * `var'1

gen `a'_T2_t1= `a' * `var'2_t1
gen `a'_T2_t2= `a' * `var'2_t2
gen `a'_T2_t3= `a' * `var'2_t3
gen `a'_T2= `a' * `var'2
}
}

//Creation of combinations of treatment and other variables 

foreach  a in pp_int_gra_0 cultivos_ilicitos_0 sometieron_gra_0 imponen_reglas_0 obligan_cultivosi_0 ///
			no_cultivos_trad_0 no_inversion_finca_0 quitan_ganado_0 quitan_cosecha_0 exigen_dinero_0 {
			
gen `a'_t1= `a' * ola_t1
gen `a'_t2= `a' * ola_t2
gen `a'_t3= `a' * ola_t3
}

ihstrans own_buy_count15 own_buy_countm ing_trabnoagr ing_trabagr own_f_work_benefit vr_ahorro

//Creation of constrains for the treatments in triple interaction

gen ahorro_inv= ahorro_casa | ahorro_montar | ahorro_mejoras | ahorro_carro 
replace ahorro_inv=. if ahorro_casa==. | ahorro_montar==. | ahorro_mejoras==. | ahorro_carro==. 


foreach var in pp_int_gra_0 sometieron_gra_0 imponen_reglas_0 no_cultivos_trad_0 no_inversion_finca_0 ///
ahorro_futuro ahorro_educ ahorro_casa ahorro_carro ahorro_otros_act ahorro_recre ahorro_montar ahorro_mejoras ///
 ahorro_deudas ahorro_salud ahorro_emerg quitan_ganado_0 quitan_cosecha_0 exigen_dinero_0 {

gen `var'_i=`var'
replace `var'_i=0 if `var'_i==.
}

replace imponen_reglas_0 = 1 if imponen_reglas_0==4
replace imponen_reglas_0_i=1 if imponen_reglas_0_i==4
replace quitan_ganado_0 = 1 if quitan_ganado_0==5
replace quitan_ganado_0_i=1 if quitan_ganado_0_i==5
replace quitan_cosecha_0 = 1 if quitan_cosecha_0==6
replace quitan_cosecha_0_i=1 if quitan_cosecha_0_i==6
replace exigen_dinero_0 = 1 if exigen_dinero_0==7
replace exigen_dinero_0_i=1 if exigen_dinero_0_i==7

gen error_gr= 1 if grarmados_2016==1 | grarmados_2015==1 | grarmados_2014==1
gen error_con=1 if sometieron_gra==1 | imponen_reglas==1 | no_cultivos_trad==1 | no_inversion_finca==1 | ///
                quitan_ganado==1 | quitan_cosecha==1 | exigen_dinero==1 & ola==3
				
///Balancing the panel 

tempvar q
bysort consecutivo: gen `q' = _n
gen byte balanced = 0
replace balanced = 1 if `q'==3

bysort consecutivo: egen a= max(balanced)
gen b=1 if consecutivo_c==8888888
gen consecutivo_c2=.
bysort consecutivo(consecutivo_c): replace consecutivo_c2 = consecutivo_c[1]
gen balanced2=1 if consecutivo_c2==consecutivo_c

gen balanced21= balanced2 if ola==1 & a==1
gen balanced22= balanced2 if  ola==2 & a==1
gen balanced23= balanced2 if  ola==3 & a==1

bysort consecutivo(consecutivo_c): replace consecutivo_c2 = consecutivo_c[1]

bysort consecutivo: egen c1= max(balanced21)
bysort consecutivo: egen c2= max(balanced22)
bysort consecutivo: egen c3= max(balanced23)

gen balanced3=1 if c1==c2==c3
replace balanced3=. if c2!=c3

//Creation of presence variable

forvalues i=2008(1)2016 {

gen gr_`i' = grarmados_`i'
replace gr_`i'=0 if gr_`i'==.
}

gen gr_ola1=(gr_2008+gr_2009+gr_2010)
gen gr_ola2=(gr_2011+gr_2012+gr_2013)
gen gr_ola3=(gr_2014+gr_2015+gr_2016)

gen presence= gr_ola1 if ola==1
replace presence= gr_ola2 if ola==2
replace presence = gr_ola3 if ola==3

gen presence2= grarmados_2010 if ola==1
replace presence2 = grarmados_2013 if ola==2
replace presence2 = grarmados_2016 if ola==3

ihstrans farm_inv tamano permanentes transitorios mixtos ganaderia pastos bosques otros_usos tierra_no_usada salary_tot debth_value debth_final

gen short=transitorios + mixtos
  
  gen frontier= pastos + bosques + tierra_no_usada
  
  gen frontier2= bosques + tierra_no_usada
  
  gen productive=ganaderia + transitorios + mixtos + permanentes
  
  gen cop = ganaderia + transitorios + mixtos
  
  gen live = pastos + ganaderia
  
  gen crops = transitorios + mixtos + permanentes
  
  ihstrans short frontier frontier2 productive crops cop live
  
  
  gen sav=vr_ahorro/vr_gtos_mensuales

//////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////// Estimates //////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

     // Lable variables 

label variable treatment1                               "Treatment1"
label variable treatment2                               "Treatment2"
label variable ola_t1                                   "T1"
label variable ola_t2                                   "T2"
label variable ola_t3                                   "T3"
label variable treatment1_t1                            "Treatment1 * T1"
label variable treatment1_t2                            "Treatment1 * T2"
label variable treatment1_t3                            "Treatment1 * T3"
label variable treatment2_t1                            "Treatment2 * T1"
label variable treatment2_t2                            "Treatment2 * T2"
label variable treatment2_t3                            "Treatment2 * T3"

winsor farm_inv, p(.01) gen(w1_farm_inv)
gen w1_farm_inv_1000 = w1_farm_inv/1000
gen pasture = pastos + ganaderia
gen fallow_land = bosques + tierra_no_usada

winsor permanentes, p(.01) gen(w1_permanentes)
winsor short, p(.01) gen(w1_short)
winsor live, p(0.01) gen(w11_live)	
winsor fallow_land, p(0.01) gen(w1_fallow_land)
winsor bosques, p(0.01) gen(w1_bosques)
winsor tierra_no_usada, p(0.01) gen(w1_tierra_no_usada)
winsor tamano, p(0.01) gen(w11_tamano)

gen w1_tamano=w1_permanentes + w1_short + w11_live + w1_fallow_land
gen ola2=1 if ola==1
replace ola2=2 if ola==3
replace ola2=0 if ola==2
gen ola3=1 if ola==3 
replace ola3=0 if ola==2 | ola==1

gen w1_productive= w1_short + w1_permanentes + w11_live
gen w1_permanentes_1000 =w1_permanentes*1000
gen w1_short_1000=w1_short*1000

ihstrans w1_permanentes w1_short w11_live  w1_fallow_land w1_productive  w11_tamano w1_farm_inv_1000 
gen per_permanentes = w1_permanentes/w11_tamano
gen per_short = w1_short/w11_tamano
gen per_live = w11_live/w11_tamano
gen per_fallow = w1_fallow_land/w11_tamano
gen per_productive = w1_productive/w11_tamano
gen per_forest = w1_bosques/w11_tamano
gen per_no_used = w1_tierra_no_usada/w11_tamano

gen prop = debth_value/vr_gtos_mensuales
gen prop_sav = vr_ahorro/vr_gtos_mensuales
winsor prop, p(.01) gen(w1_prop)

gen leasing = _ttipo_tene_6==1 | _ttipo_tene_7==1 | _ttipo_tene_8==1 | _ttipo_tene_9==1 | _ttipo_tene_11==1 | _ttipo_tene_12==1 
gen legal = _ttipo_tene_6==1 | _ttipo_tene_7==1 | _ttipo_tene_8==1 | _ttipo_tene_9==1 | _ttipo_tene_11==1 | _ttipo_tene_12==1 | propietario==1
gen ilegal = _ttipo_tene_1==1 | _ttipo_tene_2==1 | _ttipo_tene_3==1 | _ttipo_tene_4==1 | _ttipo_tene_5==1 
replace leasing =. if propietario==.
replace legal = . if propietario==.
replace ilegal = . if propietario==.

gen comp_ola=1 if ola==1 
replace comp_ola=1 if ola==2

gen lider_class_comunal = cargo_lider1 ==1
gen lider_class_religioso = cargo_lider1 ==2
gen lider_class_politico = cargo_lider1 ==3
gen lider_class_docente = cargo_lider1 ==5
replace sexo_lider1=0 if sexo_lider1==2

gen balanced_table = 1 if relevant==1 & error_gr!=1 & error_con!=1  & a==1 & b!=1 & balanced2==1 & balanced3==1

rename homicidios_d murders
rename secuestros_d kidnappings


gen supplier_debt = stores==1 | cooperative==1 
replace supplier_debt = 0 if supplier_debt==.
replace supplier_debt = . if stores==. & cooperative==. 

gen informal_debt = family==1 | friends==1 | illegal_loan==1
replace informal_debt = 0 if informal_debt==.
replace informal_debt = . if family==. & friends==. & illegal_loan==. 

foreach var in supplier_debt bank informal_debt {

replace `var' = 0 if `var'==.
replace `var' = . if debth_value==.
}

gen FARC_neigh = 1
replace FARC_neigh = 0 if id_depto==14
replace FARC_neigh = 1 if region==9

gen crime = 0
replace crime = 1 if id_depto==15




