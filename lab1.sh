#!/bin/bash

cd ~
rm -rf lab0
mkdir lab0
cd lab0
git init
mkdir -p claude_monet/hall
mkdir -p claude_monet/reception
mkdir -p claude_monet/bar
mkdir -p claude_monet/terrace
mkdir -p claude_monet/kitchen
mkdir -p claude_monet/staff_room

cat > claude_monet/hall/table_plan << 'EOF'
Столик 1 закреплён за Настей
Столик 4 обслуживает Саша
Столик 7 оставить для Дмитрия Нагиева
Большой стол подготовить к банкету
EOF
cat > claude_monet/hall/guest_requests << 'EOF'
Гости у окна просят позвать Вику
За столиком 4 ждут десерт от Луи
Постоянный гость заказал блюдо Баринова
EOF
cat > claude_monet/reception/reservations << 'EOF'
Семья заказала столик на шесть часов
Друзья Кости придут после вечерней смены
Для владельца ресторана оставлен столик 7
Настя подтвердила все бронирования
EOF
cat > claude_monet/reception/complaints << 'EOF'
Гость слишком долго ждал горячее
За столиком 2 перепутали заказ
Вика обещала лично решить проблему
EOF
cat > claude_monet/bar/kostya_shift << 'EOF'
Костя открывает бар перед обедом
Проверяет запасы и получает лёд
После закрытия сдаёт отчёт Вике
EOF
cat > claude_monet/bar/cocktail_card << 'EOF'
Коктейль от Кости с вишнёвым соком
Безалкогольный напиток для Насти
Фирменный коктейль Claude Monet
EOF
cat > claude_monet/terrace/banquet_plan << 'EOF'
На террасе поставить восемь столов
Гостей встречают Вика и Настя
Костя готовит напитки к семи часам
Баринов представляет праздничное меню
EOF
cat > claude_monet/kitchen/special_orders << 'EOF'
Столик 1 просит блюдо без лука
Для столика 7 готовит лично шеф
Гостям на террасе подать десерт Луи
EOF
cat > claude_monet/staff_room/nastya_note << 'EOF'
Настя поменялась сменой с официанткой
Костя обещал встретить её после работы
Вика разрешила закончить смену раньше
EOF
cat > vika_report << 'EOF'
Зал готов к открытию
Официанты получили свои столики
Все жалобы нужно передать Вике
EOF
cat > nagiev_call << 'EOF'
Дмитрий Нагиев позвонил перед открытием
Владелец приедет с гостями вечером
Лучший стол должен быть свободен
EOF

chmod 755 claude_monet
chmod 644 claude_monet/hall/table_plan
chmod 750 claude_monet/reception
chmod 600 claude_monet/reception/complaints
chmod 640 claude_monet/bar/kostya_shift
chmod 750 claude_monet/terrace
chmod 640 claude_monet/kitchen/special_orders
chmod 750 claude_monet/staff_room

chmod u=rwx,g=rx,o=rx claude_monet/hall
chmod u=rw,g=r,o= claude_monet/hall/guest_requests
chmod u=rw,g=r,o=r claude_monet/reception/reservations
chmod u=rwx,g=rx,o=x claude_monet/bar
chmod u=r,g=r,o=r claude_monet/bar/cocktail_card
chmod u=rw,g=r,o= claude_monet/terrace/banquet_plan
chmod u=r,g=r,o= claude_monet/staff_room/nastya_note
chmod u=rw,g=r,o=r nagiev_call

git add .
git commit -m "Часть 1"

cp vika_report claude_monet/reception/manager_report
cp -r claude_monet/terrace claude_monet/hall/terrace_backupr
cd claude_monet/bar
ln -s ../reception/reservations current_reservations
cd ~/lab0
ln -s claude_monet/hall guest_hall
ln nagiev_call claude_monet/reception/owner_call
cat claude_monet/reception/reservations claude_monet/terrace/banquet_plan > claude_monet/reception/evening_guests
cat claude_monet/staff_room/nastya_note >> vika_report
mv claude_monet/reception/complaints claude_monet/hall/guest_complaints

git add .
git commit -m "Часть 2"

ls -lR claude_monet | grep '^-' | sort -k5 -n -r | head -n 6
grep -rihE 'вик|наст' . | grep -vi 'столик' | sort -r | head -n 5
grep -l -r -i 'гост' claude_monet/hall/table_plan claude_monet/hall/guest_requests claude_monet/hall/guest_complaints claude_monet/hall/terrace_backup | wc -l
{ head -n 1 claude_monet/bar/kostya_shift; tail -n 1 claude_monet/bar/kostya_shift; head -n 1 claude_monet/bar/cocktail_card; tail -n 1 claude_monet/bar/cocktail_card; } | grep -i -E 'кост|вик' | sort
grep -vi 'столик' claude_monet/reception/evening_guests | sort -r | head -n 4 | wc -w
ls -lR . | grep '^-' | grep -E '^-([-r][-w][-x]){3} +2 ' | sort -k9 -r
ls -lR . | grep '^l' | grep -vi 'guest' | sort -k9

rm claude_monet/staff_room/nastya_note
rm claude_monet/bar/current_reservations
rm guest_hall
rm nagiev_call
rm claude_monet/reception/owner_call
rm claude_monet/terrace/banquet_plan
rmdir claude_monet/terrace
rm -r claude_monet/hall/terrace_backup

git add .
git commit -m "Final"
git remote add origin https://github.com/N1ckLarTick/lab1.git
git branch -M main
git push -u origin main
