--DAL - Yatogami Tohka
function c99970021.initial_effect(c)
  --Negate Attack
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_BE_BATTLE_TARGET)
  e1:SetTarget(c99970021.natg)
  e1:SetOperation(c99970021.naop)
  c:RegisterEffect(e1)
  --To Hand
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e2:SetCode(EVENT_DESTROYED)
  e2:SetCondition(c99970021.thcon)
  e2:SetTarget(c99970021.thtg)
  e2:SetOperation(c99970021.thop)
  c:RegisterEffect(e2)
end
function c99970021.spfilter(c,e,tp)
  return c:IsCode(99970040) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970021.natg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
end
function c99970021.naop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.NegateAttack() and c:IsRelateToEffect(e) then
  Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  local g=Duel.GetMatchingGroup(c99970021.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
  if g:GetCount()>0 then
  Duel.BreakEffect()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g1=g:Select(tp,1,1,nil)
  Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
  end
  end
end
function c99970021.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT)
end
function c99970021.thfilter(c)
  return c:IsCode(99970000) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99970021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970021.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970021.thop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99970021.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end