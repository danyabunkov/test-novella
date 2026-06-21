# 10 проектов: полный гейм-дизайн + промпты

**Состав портфеля** (от лёгкого к сложному, как ты просил — больше лёгких, меньше тяжёлых):

| # | Название (раб.) | Жанр | Движок | Сложность | Цикл | Цена |
|---|---|---|---|---|---|---|
| 1 | **One Tile Left** | Минималист-пазл (block/sort) | Godot | Очень лёгкая | 2–3 нед | $2.99 / free+ads |
| 2 | **Lumen** | Пазл со светом/зеркалами | Godot | Лёгкая | 3–4 нед | $3.99 |
| 3 | **Tidy Hearth** | Уютный пазл-органайзер | Godot | Лёгкая | 4 нед | $5.99 |
| 4 | **Last Train Home** | Casual-аркада (раннер-таймкиллер) | Godot | Лёгкая | 3 нед | free+ads / $1.99 |
| 5 | **Glasshouse** | Hidden-object + лёгкий нарратив | Godot | Средняя-лёгкая | 5 нед | $4.99 |
| 6 | **Postcards from Nowhere** | Кинетическая новелла (короткая) | Ren'Py | Лёгкая | 3–4 нед | $4.99 |
| 7 | **The Lighthouse Keeper** | Атмосферная VN (ветвление) | Ren'Py | Средняя | 6–8 нед | $9.99 |
| 8 | **Signal** | Мистери-VN с механикой расследования | Ren'Py | Средняя+ | 8–10 нед | $12.99 |
| 9 | **Ink & Tea** | Уютная VN-симулятор (кафе) | Godot+Dialogic | Средняя | 8 нед | $9.99 |
| 10 | **The Hollow Year** | Большая сюжетная VN (хоррор-мистика) | Ren'Py | Высокая | 12–16 нед | $14.99 |

**Стратегическая логика портфеля:** 1–5 — быстрые «учебные» проекты, на которых ты обкатываешь конвейер, LoRA и публикацию (по выводам анализа: первые игры = платное обучение). 6–9 — средний слой, где уже можно целиться в заметную выручку. 10 — флагман с сильным хуком, куда вкладываешься после того, как конвейер отлажен. Делай **последовательно, не параллельно**: 1→2→3 на одном движке копят мышечную память и переиспользуемый код.

> **Про каждый проект ниже даётся:** концепт и хук, жанр/стиль, кор-луп и механики, структура/сюжет, объём контента, что генерим (персонажи/фоны/CG), готовые арт-промпты, план LoRA, движок и ключевые узлы реализации, цикл разработки по неделям, риски.

> **Общий стиль-дисциплина для всех:** в каждом проекте фиксируется `style_base` (префикс промпта + негатив + палитра + сэмплер). Префикс примерно: `masterpiece, best quality, highly detailed, <стиль проекта>, consistent lighting`. Негатив-бэйз: `lowres, bad anatomy, bad hands, extra fingers, watermark, signature, jpeg artifacts, deformed, mutated, text`. Дальше у каждого — свой стилевой слой.

---

## ПРОЕКТ 1 — One Tile Left
**Жанр:** минималистичный логический пазл (родственник block-blast / sort-puzzle). **Движок:** Godot. **Цена:** $2.99 или free+реклама.

**Хук (одна строка):** «Каждый уровень решается ровно одним способом — и ты это чувствуешь.»

**Кор-луп:** поле NxN, набор фигур/плиток, цель — разместить/убрать так, чтобы остался ровно один тайл в нужной клетке. Чистый детерминированный пазл, без рандома, без проигрыша по времени. 5–10 сек на «понять», приятный щелчок на «решить».

**Механики:**
- Сетка + перетаскивание фигур (drag-drop), snap to grid.
- Условие победы: единственная валидная конфигурация.
- 120 уровней, 4 мира по нарастанию правил (гравитация → телепорты → цветовые ограничения → комбо).
- Дейли-пазл (по выводам анализа — драйвер привычки даже в премиуме).
- Без текста → локализация почти не нужна (большой плюс к скорости).

**Что генерим:** почти ничего «художественного». Стиль — **геометрический минимализм**, можно почти полностью на CC0 UI (Kenney). ИИ-генерация только для: фоновые градиенты-паттерны 4 миров + иконка/капсула Steam.

**Арт-промпт (фоны миров), готов к копипасту:**
```
minimalist abstract background, soft gradient, geometric subtle pattern,
muted pastel palette (world 1: warm sand; world 2: cool teal; world 3: dusk
purple; world 4: deep indigo), clean, flat design, no characters, no text,
calm, high resolution, suitable as game background, negative space
```
**Капсула Steam:**
```
clean minimalist puzzle game key art, single glowing tile on a geometric
grid, soft rim light, modern flat illustration, calm premium aesthetic,
centered composition, no text, store capsule
```
**LoRA:** не нужна (нет персонажей).

**Реализация (Godot):** TileMap/GridContainer, ресурс уровня = JSON (легко генерить уровни Claude Code'ом и валидировать солвером). Напиши **солвер-валидатор** (проверяет «ровно одно решение») — это центральный кусок, его и поручи агенту в первую очередь.

**Цикл:** Нед.1 — кор-механика + солвер. Нед.2 — 120 уровней (генерация + валидация) + дейли. Нед.3 — полировка, звук (Kenney), сборка, страница Steam.

**Риск:** жанр перенасыщен на мобайле → метить в премиум-PC-нишу «чистый дзен-пазл», а не в free-mobile войну за трафик.

---

## ПРОЕКТ 2 — Lumen
**Жанр:** головоломка со светом и зеркалами. **Движок:** Godot. **Цена:** $3.99.

**Хук:** «Проведи свет сквозь темноту — каждый луч рисует решение.»

**Кор-луп:** на поле источник света и цель; игрок ставит/вращает зеркала, призмы, фильтры, чтобы довести луч до цели.光-puzzle с приятной визуальной обратной связью (свет — это всегда красиво и стримится).

**Механики:** зеркала (отражение), призмы (расщепление на RGB), цветные двери (нужен луч нужного цвета), стекло/линзы. 80 уровней, сложность через комбинации. Подсказки за «звёзды». Без текста сюжета → локализация минимальная (только UI).

**Что генерим:** фоны-окружения (тёмные атмосферные «камеры»), световые эффекты — частично шейдерами в Godot, частично текстуры. Стиль — **тёмный минимализм с неоновым светом**.

**Арт-промпт (фоны-камеры):**
```
dark minimalist puzzle chamber, atmospheric, subtle geometric architecture,
deep shadows, faint volumetric light, neon accent glow (cyan/magenta),
clean composition, no characters, no text, moody, high detail, game background
```
**Промпт (иконки оптических элементов — для референса, финал лучше векторный/CC0):**
```
glowing optical puzzle element icon, <mirror / prism / lens / color filter>,
neon edge light on dark background, clean minimal, centered, no text
```
**LoRA:** не нужна. Свет делается шейдером (Light2D + кастомный) — основная техническая работа здесь, не арт.

**Реализация (Godot):** raycasting луча по сетке, отражение по нормали зеркала, расщепление в призме. Key-узел — **движок распространения луча** (рекурсивный raycast с отражениями/преломлениями). Поручи агенту его + редактор уровней.

**Цикл:** Нед.1 — луч+зеркала. Нед.2 — призмы/цвета/двери. Нед.3 — 80 уровней. Нед.4 — шейдеры света, полировка, сборка.

**Риск:** баланс сложности кривой обучения — нужны 8–10 обучающих уровней без стены.

---

## ПРОЕКТ 3 — Tidy Hearth
**Жанр:** уютный пазл-органайзер (в духе A Little to the Left). **Движок:** Godot. **Цена:** $5.99.

**Хук:** «Наводи уют в чужих домах — и находи историю в их вещах.»

**Кор-луп:** сцена-комната с беспорядком; игрок сортирует/выравнивает/группирует предметы по «приятной» логике (цвет, размер, тип). Несколько валидных решений (как у референса) → ощущение свободы, не наказание. Без фейла, без таймера = «уютный» сегмент, который растёт.

**Механики:** drag-drop предметов, snap, распознавание «упорядоченного» состояния (несколько допустимых), мягкие подсказки. 60 сцен, лёгкая сквозная история «через предметы» (нарратив без текста или с минимумом). Дейли-режим уборки.

**Что генерим:** **много предметных спрайтов и фонов-комнат** — здесь ИИ-конвейер реально экономит. Стиль — **тёплая мягкая 2D-иллюстрация, cozy, рисованная**.

**Style_base (зафиксировать):** `cozy hand-drawn illustration, warm soft lighting, gouache texture, muted homely palette, gentle, wholesome`

**Арт-промпт (комната-фон):**
```
cozy hand-drawn illustration of a <kitchen / study / child bedroom / attic>,
warm afternoon light, gouache texture, muted homely palette, soft shadows,
lived-in details, slightly messy, top-down or 3/4 view, no characters,
no text, wholesome atmosphere, high detail, game scene background
```
**Арт-промпт (предметный спрайт, для атласа):**
```
single household object sprite, <book / mug / folded blanket / potted plant>,
cozy hand-drawn gouache style, warm palette, soft shadow, isolated on
transparent background, centered, consistent style, no text
```
**LoRA:** **стилевая LoRA** (не на персонажа, а на стиль) — обучи на 20–30 своих лучших предметных генерациях, чтобы все 300+ предметов держали единый облик. Это ключ к цельности.

**Реализация (Godot):** Area2D + drag, состояние сцены = граф «приятности», валидатор нескольких решений. Атлас спрайтов. Узел — **детектор упорядоченного состояния** (несколько целевых конфигов с допуском).

**Цикл:** Нед.1 — drag+детектор. Нед.2 — стилевая LoRA + первые 20 сцен. Нед.3 — ещё 40 сцен + предметы. Нед.4 — дейли, звук, полировка, Steam.

**Риск:** «несколько валидных решений» сложно формализовать — заложи время на тюнинг допусков.

---

## ПРОЕКТ 4 — Last Train Home
**Жанр:** казуальная аркада-таймкиллер (раннер/уворот, одна кнопка). **Движок:** Godot. **Цена:** free+реклама или $1.99.

**Хук:** «Один палец, последний поезд, бесконечная ночь.»

**Кор-луп:** бесконечный/уровневый раннер: персонаж бежит за уходящим поездом по ночному городу, уворачивается, собирает. Score-chase, мгновенный рестарт, «ещё один забег». Это твой «гипер-казуальный» эксперимент по ретеншену/рекламе.

**Механики:** one-tap (прыжок/смена линии), процедурные препятствия, комбо за near-miss, ежедневная цель, лидерборд (можно на твоём Supabase). Реклама с rewarded-video на продолжение (по анализу — IAA-модель).

**Что генерим:** параллакс-фоны ночного города + спрайт бегуна (анимация — можно из спрайт-листа). Стиль — **неоновый ночной пиксель/силуэт** (силуэты проще держать консистентными в ИИ).

**Арт-промпт (параллакс-фон):**
```
side-scrolling night city parallax background, neon silhouette style,
rain-slick streets, glowing windows, moody blue-purple palette, layered
depth (foreground/midground/background separated), no characters, no text,
seamless horizontal tiling, game art
```
**Арт-промпт (бегун, как силуэт-спрайт):**
```
running character silhouette sprite sheet frames, side view, dynamic run
cycle, neon rim light, dark filled body, minimal detail, consistent
proportions, transparent background, no text
```
**LoRA:** лёгкая стилевая LoRA на «неон-силуэт», если фоны поплывут. Персонаж-силуэт консистентен и без LoRA.

**Реализация (Godot):** процедурный спавн, параллакс (ParallaxBackground), один input. Узел — **генератор препятствий с гарантией проходимости**. Реклама — через плагин (для веб/мобайл) или отложить на мобильную версию.

**Цикл:** Нед.1 — кор-раннер. Нед.2 — процедурка + комбо + лидерборд. Нед.3 — арт, звук, реклама, сборка.

**Риск:** аркадный таймкиллер на Steam-премиуме продаётся слабо → это кандидат на **бесплатный веб/мобайл** для обкатки рекламы и ретеншена, а не на платный Steam.

---

## ПРОЕКТ 5 — Glasshouse
**Жанр:** hidden-object (поиск предметов) + лёгкий нарратив. **Движок:** Godot. **Цена:** $4.99.

**Хук:** «В заброшенной оранжерее каждый найденный предмет — обрывок чьей-то жизни.»

**Кор-луп:** богато детализированные сцены; игрок ищет предметы из списка; находки открывают кусочки истории (дневник прежнего хозяина). Спокойный темп, лупа/зум, подсказки.

**Механики:** клик-поиск, список целей, зум-инспекция, между сценами — короткие нарративные вставки (тут уже нужен EN+RU текст, но немного). 12 сцен-локаций, сквозная история-мистерия (куда исчез ботаник?).

**Что генерим:** **детализированные сцены-оранжереи** — идеально для ИИ (богатая текстура, прячущая «предметы»). Стиль — **полу-реалистичная атмосферная иллюстрация, зелёный сумрак**.

**Style_base:** `semi-realistic atmospheric illustration, overgrown greenhouse, green dim light, painterly detail, melancholic, rich texture`

**Арт-промпт (сцена-локация):**
```
semi-realistic atmospheric illustration of an abandoned overgrown
greenhouse interior, <section: orchid room / potting bench / broken
glass dome / flooded corner>, dim green light through dirty glass,
lush overgrown plants, scattered objects, dust motes, painterly rich
detail, melancholic mood, no visible text, wide scene, hidden-object
game scene, high detail
```
**LoRA:** стилевая LoRA на «overgrown greenhouse painterly» (20–30 картинок) для единства 12 сцен.

**Реализация (Godot):** сцена = большое изображение + слой кликабельных Area2D (координаты предметов). Узел — **редактор разметки предметов** (кликаешь по картинке → сохраняется хитбокс). Нарратив-вставки — простой текстовый оверлей с локализацией (CSV EN/RU).

**Цикл:** Нед.1 — механика поиска + разметка. Нед.2–3 — стилевая LoRA + 12 сцен + предметы. Нед.4 — нарратив EN+RU, подсказки. Нед.5 — полировка, Steam.

**Риск:** контроль «честности» спрятанных предметов (не слишком замаскированы) — нужен плейтест.

---

## ПРОЕКТ 6 — Postcards from Nowhere
**Жанр:** короткая кинетическая новелла (почти без ветвления). **Движок:** Ren'Py. **Цена:** $4.99.

**Хук:** «Незнакомец шлёт тебе открытки из мест, которых нет на карте.»

**Структура:** линейная история ~1.5–2 часа, разбитая на «открытки» (главы-локации). Минимум выборов (2–3 развилки концовки) → быстрый продакшн, фокус на тексте и атмосфере. Твой первый VN-проект для обкатки Ren'Py + персонаж-LoRA.

**Контент:** ~15–20k слов EN, затем RU-локализация. 1 главный «голос» (рассказчик/отправитель), игрок — молчаливый получатель. 8–10 «открыток»-локаций.

**Что генерим:** **8–10 «открыток» (живописные локации)** + 1–2 ключевых CG. Персонажей-спрайтов почти нет (история через места) → минимум LoRA-работы. Стиль — **романтичный иллюстративный пейзаж, ретро-открытка**.

**Style_base:** `nostalgic travel postcard illustration, painterly, warm faded colors, soft grain, dreamy, slightly surreal`

**Арт-промпт (открытка-локация):**
```
nostalgic travel postcard illustration of <impossible place: a city that
floats at dusk / a train station with no trains / a lighthouse in a desert>,
painterly, warm faded retro colors, soft film grain, dreamy slightly
surreal atmosphere, no people, no text, wide scenic composition, high
detail, visual novel background
```
**LoRA:** **стилевая LoRA** на «postcard painterly» — чтобы 10 открыток были одной серией. Персонаж-LoRA не нужна.

**Реализация (Ren'Py):** чистый Ren'Py, label на главу, 2–3 концовки через флаги. Узел — **система «получения открытки»** (анимация прихода + смена фона). Локализация — встроенный Ren'Py translate.

**Цикл:** Нед.1 — сценарий EN. Нед.2 — стилевая LoRA + открытки. Нед.3 — сборка в Ren'Py + музыка. Нед.4 — RU-локализация, полировка, Steam.

**Риск:** кинетические новеллы (без выбора) хуже продаются — компенсируй сильным хуком и короткой ценой.

---

## ПРОЕКТ 7 — The Lighthouse Keeper
**Жанр:** атмосферная VN с ветвлением. **Движок:** Ren'Py. **Цена:** $9.99.

**Хук:** «Ты — смотритель маяка. Каждую ночь к берегу приходит кто-то новый. Не каждого стоит впускать.»

**Структура:** ~3–4 часа, ветвление через выбор «кого впустить / как ответить». 4–5 концовок. 5–6 персонажей-«гостей», каждый — мини-арка за ночь. Морально-атмосферная мистика.

**Контент:** ~35–45k слов EN + RU. 5–6 персонажей со спрайтами (3–4 эмоции каждый) + смотритель (можно без портрета, от первого лица). ~6–8 CG ключевых сцен.

**Что генерим:** **5–6 персонажей (LoRA на каждого!)**, маяк/берег/комната-фоны, CG. Стиль — **мрачноватая атмосферная полу-реалистичная иллюстрация, морской нуар**.

**Style_base:** `atmospheric semi-realistic illustration, coastal night, storm and fog, muted cold palette, cinematic lighting, painterly, moody maritime`

**Арт-промпт (персонаж-спрайт, пример — «утопленница-гостья»):**
```
visual novel character sprite, full body, <pale woman in soaked Victorian
coat, seaweed in dark hair, sorrowful eyes / weathered old sailor with
lantern / child in oversized raincoat>, atmospheric semi-realistic painterly
style, muted cold maritime palette, cinematic rim light, neutral standing
pose, transparent background, consistent character design, no text
```
*(вариации эмоций: добавляй `expression: neutral / fearful / pleading / smiling faintly`, держи тот же сид + LoRA)*

**Арт-промпт (фон — комната маяка):**
```
visual novel background, interior of a lighthouse keeper's room at night,
warm lantern light vs cold window storm, worn wooden details, maps and
ropes, atmospheric painterly semi-realistic, moody, no characters, no text,
wide, high detail
```
**Арт-промпт (CG — ключевая сцена):**
```
visual novel CG event illustration, the keeper opening the door to a
storm-lashed figure on the threshold, dramatic cinematic lighting, rain,
lighthouse beam cutting fog, atmospheric painterly semi-realistic, emotional,
no text, high detail, 16:9
```
**LoRA-план:** обучи **отдельную LoRA на каждого из 5–6 гостей** (15–30 рефов: генеришь персонажа в Midjourney/SDXL, отбираешь консистентные, обучаешь). Это половина арт-работы проекта — заложи время.

**Реализация (Ren'Py):** ветвление через переменные «доверие/подозрение» по каждому гостю → концовка по сумме. Узел — **система ночей** (меню выбора гостя → сцена → последствие). Галерея CG как анлок.

**Цикл:** Нед.1–2 — сценарий+ветвление EN. Нед.3–4 — LoRA на персонажей + спрайты/эмоции. Нед.5 — фоны+CG. Нед.6 — сборка Ren'Py, музыка. Нед.7 — RU. Нед.8 — полировка, демо, Steam.

**Риск:** консистентность 6 персонажей через LoRA — главная техническая нагрузка; не экономь на датасетах.

---

## ПРОЕКТ 8 — Signal
**Жанр:** мистери-VN с механикой расследования. **Движок:** Ren'Py (+ кастомные экраны). **Цена:** $12.99.

**Хук:** «Радиолюбитель ловит передачу, которой не должно существовать. У тебя 7 ночей, чтобы понять, кто говорит.»

**Структура:** ~5–6 часов, 7 «ночей»-глав. Между сценами — **механика расследования**: доска улик, сопоставление частот/записей, дедукция (выбор «кто/что/почему»). Ветвление + несколько концовок (правда / паранойя / тишина).

**Контент:** ~45–55k слов EN + RU. 3–4 персонажа (голоса в эфире + 1–2 очных) + протагонист. Доказательная база (улики-объекты, аудио-описания). ~6–8 CG.

**Что генерим:** персонажи (LoRA), интерьер радиорубки и «видения» из эфира, улики-предметы, CG. Стиль — **холодный ретро-техно-нуар, 70-е, зерно плёнки, паранойя**.

**Style_base:** `cold retro techno-noir illustration, 1970s analog, film grain, desaturated teal and amber, paranoid atmosphere, painterly realism`

**Арт-промпт (фон — радиорубка):**
```
visual novel background, cramped 1970s radio operator's room at night,
glowing analog dials and reel-to-reel tape, cigarette smoke, cold teal and
amber light, film grain, paranoid claustrophobic mood, painterly realism,
no characters, no text, wide, high detail
```
**Арт-промпт (улика-объект для доски):**
```
single evidence object on dark surface, <reel tape labeled with numbers /
hand-drawn frequency map / faded photograph / torn transcript>, top-down,
1970s analog, film grain, desaturated, isolated, soft shadow, no readable
text, investigation board item
```
**Арт-промпт (CG — «видение из эфира»):**
```
visual novel CG, surreal vision bleeding through radio static, distorted
figure made of signal noise, cold light, analog glitch, unsettling dreamlike,
painterly techno-noir, film grain, no text, 16:9, high detail
```
**LoRA-план:** LoRA на 1–2 очных персонажа; «голоса» можно подать через абстрактные сигнал-визуалы (меньше LoRA). Стилевая LoRA на «techno-noir grain» для единства.

**Реализация (Ren'Py + Python-экраны):** кастомный **screen «доска улик»** (drag связи между уликами), проверка дедукции, флаги паранойи. Это самый «инженерный» из VN — твой бэкграунд тут плюс. Узлы: система ночей + механизм дедукции + аудио-дизайн (эфир — важная часть атмосферы).

**Цикл:** Нед.1–2 — сценарий+дизайн расследования. Нед.3–4 — механика доски улик (код). Нед.5–6 — LoRA+арт+CG. Нед.7 — аудио+сборка. Нед.8 — RU. Нед.9–10 — баланс дедукции, демо, Steam.

**Риск:** механика дедукции легко сделать или слишком тупой, или нечестной — критичен плейтест баланса подсказок.

---

## ПРОЕКТ 9 — Ink & Tea
**Жанр:** уютная VN-симулятор (кафе + отношения). **Движок:** Godot + Dialogic. **Цена:** $9.99.

**Хук:** «Открой чайную в дождливом городе. Гости приносят свои истории — ты завариваешь нужное.»

**Структура:** ~4–5 часов, гибрид: **лёгкий сим-луп** (завари чай под настроение гостя) + **новелла** (арки постоянных гостей). Дни-циклы, прогрессия кафе, дружеские (не романтические по дефолту) арки. Уютный растущий сегмент.

**Контент:** ~40–50k слов EN + RU. 6–8 постоянных гостей (спрайты + эмоции) + бариста-протагонист. Интерьер кафе (апгрейды), чашки/чаи (предметы). ~8 CG «моментов».

**Что генерим:** **много персонажей (LoRA на каждого)** + кафе-фоны (разные времена дня/сезоны) + предметы чая. Стиль — **тёплая уютная аниме-иллюстрация, дождь за окном, lo-fi**.

**Style_base:** `cozy warm anime illustration, rainy cafe, lo-fi aesthetic, soft warm lighting, gentle palette, wholesome, detailed`

**Арт-промпт (персонаж-гость, пример):**
```
visual novel character sprite, full body, <tired office worker in damp coat /
art student with paint-stained hands / elderly writer with a worn notebook>,
cozy warm anime illustration style, lo-fi soft lighting, gentle palette,
friendly approachable design, neutral standing pose, transparent background,
consistent character design, no text
```
**Арт-промпт (фон — кафе):**
```
visual novel background, cozy tea cafe interior, rain streaking the windows,
warm hanging lamps, wooden counter with teapots, plants, lo-fi wholesome
anime style, soft warm lighting, <morning / afternoon / evening / night>
variant, no characters, no text, wide, high detail
```
**LoRA-план:** LoRA на каждого из 6–8 гостей + стилевая «cozy lofi cafe». Самый «персонажеёмкий» проект после #10.

**Реализация (Godot+Dialogic):** Dialogic для диалогов, кастомный сим-луп (настроение гостя → выбор чая → реакция → очки дружбы → анлок арки). Узлы: чай-матчинг механика + менеджер дней + прогрессия кафе.

**Цикл:** Нед.1 — сим-луп+Dialogic. Нед.2–3 — сценарий арок EN. Нед.4–5 — LoRA+персонажи. Нед.6 — фоны+CG+предметы. Нед.7 — баланс, аудио. Нед.8 — RU, полировка, Steam.

**Риск:** баланс «сим vs новелла» — чтобы сим не надоел и не мешал истории. Держи сим лёгким.

---

## ПРОЕКТ 10 — The Hollow Year (флагман)
**Жанр:** большая сюжетная VN, хоррор-мистика с сильным ветвлением. **Движок:** Ren'Py. **Цена:** $14.99.

**Хук:** «В деревне, где год не меняется, ты — единственный, кто помнит вчера.»

**Структура:** ~8–12 часов, 5 актов, глубокое ветвление (выборы реально меняют ход), 5–7 концовок. Петля «повторяющегося года», которую игрок постепенно ломает. Это твой Slay-the-Princess-class проект: вся ставка на **концепт + текст + атмосферу**.

**Контент:** ~80–110k слов EN + RU. 6–8 значимых персонажей (богатые спрайты, много эмоций) + протагонист. ~15–20 CG. Несколько «временных» версий локаций (год циклится).

**Что генерим:** максимум арта проекта — **LoRA на 6–8 персонажей**, десятки фонов (деревня в разных «итерациях года»), 15–20 CG. Стиль — **мрачная фолк-хоррор иллюстрация, выцветшая осень, тревожная красота**.

**Style_base:** `folk horror illustration, perpetual fading autumn, muted earthy palette, unsettling beauty, painterly, cinematic, eerie stillness`

**Арт-промпт (персонаж-спрайт, пример):**
```
visual novel character sprite, full body, <village elder with knowing eyes
and homespun clothes / a girl who never ages, wreath of dead flowers / the
stranger nobody else remembers>, folk horror painterly illustration, muted
earthy autumn palette, eerie cinematic light, neutral standing pose,
transparent background, consistent character design, no text
```
*(эмоции: `neutral / unsettling smile / fear / grief / blank`, тот же сид + LoRA)*

**Арт-промпт (фон — деревня):**
```
visual novel background, isolated village trapped in perpetual autumn,
<village square / old church / misty fields / the well that should be
covered>, muted earthy palette, fading light, fallen leaves frozen
mid-air, unsettling stillness, folk horror painterly, no characters,
no text, wide cinematic, high detail
```
**Арт-промпт (CG — поворотная сцена):**
```
visual novel CG event, the moment the protagonist realizes the year has
reset again, dread and recognition, folk horror painterly, muted autumn,
cinematic dramatic light, emotionally charged, no text, 16:9, high detail
```
**LoRA-план:** полноценный набор — LoRA на каждого из 6–8 персонажей с большими датасетами (25–30 рефов, несколько ракурсов), + стилевая LoRA «folk horror autumn». Это самый тяжёлый арт-блок; делай его **после** того, как обкатал LoRA на проектах 7/9.

**Реализация (Ren'Py):** сложный граф состояний «памяти петли» (что игрок помнит между циклами), персистентные флаги, 5–7 концовок. Узлы: менеджер циклов года + система памяти + галерея. Самый сложный сценарный движок портфеля.

**Цикл (12–16 нед):** Нед.1–4 — сценарий+граф ветвления (самое важное, не торопить). Нед.5–8 — LoRA+спрайты+эмоции. Нед.9–11 — фоны+CG. Нед.12 — музыка+аудио. Нед.13 — сборка+баланс веток. Нед.14 — RU. Нед.15–16 — демо для Next Fest, полировка, Steam.

**Риск:** объём. Главная опасность — не закончить (по анализу — частая причина провала). Жёсткая дисциплина скоупа: лучше 5 сильных концовок, чем 9 недоделанных.

---
