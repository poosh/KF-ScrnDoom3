# KF-ScrnDoom3
Doom3 Monsters for Killing Floor 1 - ScrN Edition


# Credits
- Original monsters from Doom3 by id Software
- Unreal Tournament 2004's port by **INIQUITOUS**
- Initial Killing Floor port (up to BETA 4) by **Marco**:
  https://steamcommunity.com/sharedfiles/filedetails/?id=98454734
- Further development of KF-Doom3 Monsters mod and ScrN Edition by **[ScrN]PooSH**


# Version History
*Starting from v5, ScrnDoom3KF version matches the newest version of ScrN Balance available on the release day.*

### v9.66
- Enhanced headshot detection on flying monsters
- Fixed an issue when online head scale was not always applied on dedicated server
- Fixed laser projection

### v9.64
- Pinky now has a "head" hitbox. Pro-tip: shoot into its mouth.
- Optimized headshot detection for all Doom demons.
- Removed crispy effects because those look stupid on Doom demons.

### v9.63
##### Guardian
- The shock damage now is scaled across the difficulties: Normal: 40, HoE: 70.
  Previously the shock damage was constant 50.
- Default melee damage lowered to 45 (down from 90).
- Charge damage raised to 108-189 (up from 90-157).
- Guardian may charge only if the player has been detected by Seeker.
 - Melee range lowered to 2.5m (down from 5m)
 - Seekers should not back off too far away anymore
 - Seekers are running out of fuel and die in 30-90s

##### Invulnerable Hunter
- Fixed a bug that sometimes prevented Invulnerable Hunter to attack or drop shield
- Melee range increased
- Melee-locking eventually pisses him off, which, in turn, leads to multiple ranged attacks in a row

### v9.62.01
- Removed debug message from BFG projectile

### v9.62
- Restored teleportation ability of Doom monsters. Now, demons may randomly
  teleport from time to time. Small demons do teleport more often.
- Fat Zombie moves faster: 105 -> 120 ups base.

##### Varagy
- becomes more aggressive when low on health.
- Can throw multiple rocks in a raw when her health drops below 50%.

##### Berserker Hunter
- Damage multiplier to the opened chest raised to x2.5 (up from x2.0)
- Opens chest more often
- Opens chest at rage start
- Prevented infinite melee attacks in rage mode
- 666+ damage to heart during jump attack stops him from raging

##### Sabaoth
- Raised BFG projectile's health from 40 up to 100. However, now damage can be
  stacked from multiple shots. Perk damage bonus doesn't apply to BFG proj.
- Sabaoth is more likely to stay at range rather than charge a player
- Added 1s cooldown before BFG projectile starts emitting rays.
- Now it takes 1s for BFG projectile to charge fully. A partially charged projectile does less damage.

### v9.47
- Fixed bug when per-player health multiplier was applied twice for end-game bosses
- BossPerPlayerHP doesn't affect end-game boss anymore (use PatBossMult instead)

### v9.45
- Health of Doom Bosses now are scaled normally, even if not spawned by Doom3Mutator

### v9.40
- Doom Bosses made smaller.
- Added bSpawnMonsters to Doom3KF.ini allowing to turn off doom3 monster spawning
  for ScrN Waves.
- Fixed headshot detection algorithm.
- Fixed headshots of almost every Doom3 Monster.

### v9.20
All DooM monsters now have at least x1.5 headshot damage multiplier.

##### Varagy
- gained ability to spawn multiple spiders in a row.
- base health raised to 7000 (up from 5500)

##### Berserker Hunter
- Base health raised to 5000 hp (up from 4000)
- Base damage resistance lowered to 40% (down from 75%)
- Closed heart damage resistance lowered to 20% (down from 50%)
- Added x2 damage bonus to opened heart.
- Removed fire resistance.
- Berserker Hunter's heart now is open while doing jump attack.
- 666+ damage to heart during jump attack stops Berserker Hunter in mid-air.


### v8.20
- Sabaoth doesn't stuck anymore
- Destroying BFG cell in mid-air does huge amount of damage to monsters nearby
- Summoned monsters now are properly destroyed on master's death (e.g. Archvile)
- Fixed Maledict's head hitbox
- Lowered Lost Soul's damage (28->19)
- Lowered Forgottens's damage (30->27)
- Raised Cacodemon's melee damage (26->48)
- Raised Cacodemon's ranged damage (20->25)

### v8.15
- New spawn variables
- Adjusted hitboxes for Imp, Boney and Vulgar
- Lowered bounty for small monsters
- Adjusted zapping threshold and damage multiplier

#### New console commands:
- `MUTATE BIGMAP` - mark map as big (allows spawning big bosses)
- `MUTATE SMALLMAP` - mark map as small (no big bosses)
- `MUTATE ISBIGMAP` - returns current map status
- `MUTATE DOOMSTAT` - returns doom monster percentage

### v8.11
- Spawn intervals now respect map's `WaveSpawnPeriod`
- **Berserker** and **HellTime Hunters** can fit on normal maps now

##### Berserker Hunter
- When head isn't open, any damage to heart area does 50% damage (up from 25%)

##### Guardian
- Fixed head hitbox
- Killing Guardian destroys its Seekers
- Lowered Seeker health
- Seekers are invulnerable during first 2 seconds
- Longer Seeker regeneration time
- More Seekers are spawned

##### Cacodemon
- Added second head

##### Maggot
- Added second head

### v8.10
- Lowered collision radius of several monsters. They may clip though walls now,
  but at least they won't stuck so much.
- Karma file auto detection can be configured now (same as FemaleFP).
- Fixed bug when boss death didn't trigger achievements.

### v7.25
- Windows clients check for Doom3Karma.ka file and enable/disable karma ragdoll
  animations depending of its existence.

### v7.00
- Support KF v1058
- Fixed **Maggot**'s head. Due to some limitations in KF code Maggot has "only" one
  real head (which is used for counting headshots) - right head.
- Fixed **Cacodemon**'s head. Same as Maggot - aim to the right brain.
- **Invulnerable Hunter**'s max melee attack in a row lowered to 3 (down from 5)
- Minor bugfixes.

### v5.41
- Fixed a bug when some Doom monsters didn't receive full damage from explosives
- **Revenant** now has 50% damage resistance against explosives
- Raised **Hell Knight**'s per-player health bonus to 20% (up from 10%)
- Prepared for Doom3 achievement pack

### v5.40
- Projectile's damages now are scaled by difficulty.
- Adjusted projectile damages.
- HeadHealth is lowered on headshots, making it avaliable to track headshots.
- Trites spawn by Vagary have damage resistance while being in her hands.
- Max doom monsters during end game boss fight now is scaled by number of players
- End game boss now can teleport away from the players up 3 times.


### v5.31
- Made compatible with Summer'2013 update (`ScoredHeadshot()`)
- **Vagary** now summons and throws Trites (spiders) at the players


### v5.20
- Fixed references to `none` when monsters are taking environmental damage
- Implemented "smart" choise of teleport destination
- Top-tier doom monsters can't be flich-locked anymore

### v5.15
- Changed `bFatAss` propery for some monsters.

### v5.14
- If end game boss class is wrong, it will be replaced with **Sabaoth**.
- Pipe bomb threat level adjusted (e.g. single spider doesn't activate pipe anymore)

### v5.13
- Removed Forgottens from Archvile's spawn list

### v5.12
- **ScrN version system applied. Beta 12 now is v5.12**
- Fixed end game boss


### BETA 11
- Lowered **Maledict**'s damage


### BETA 10
- Fixed squad spawns in PAT wave - no more spawn spam
- Shows Pat Replacement's HP, if team gets wiped


### BETA 9
- Changed `CanKillMeYet()` behaviour: last small monsters get auto-killed faster
  while Boss can stay on the map much longer.

### BETA 8
- Fixed huge bug - players didn't get any money for killing doom monsters!
- Using of ragdoll death animation reverted to the original (Beta4). Ragdolls
  must be enabled on the client side (in *Doom3KF.ini*). Clients must have doom3
  monsters pack installed on their system to view proper death animations
  (must have *KarmaData/Doom3Karma.ka* file).
- Pat Replacement: if Boss looses > 10% HP during five seconds, extra squad will
  be spawned immediatelly.

### BETA 7
- **Fat Zombie**'s ground speed raised to Clot's speed (105)
- **Boney**'s speed raised to 100 (up to 65)

##### Revenant
- When full of health he shoots rarer (extra 2s cooldown).
- In normal conditions he shoots 1-2 rockets in a row (before was random from 1 to 4).
- When raged (health < 75%) he shoots 1-4 rockets in a row and moves x3.5 faster.


### BETA 6
- Big monsters' health now is scaled through the number of players.
- Base health lowered /1.5 times, giving 10% hp per extra pleyer.
  So 5-player team will get same-health monsters as original,
  6+ players - slightly more hp, but small teams and soloers can kill them easier.
  Monsters with scaled health: **Commando, Revenant, Bruiser, Archvile, Mancubus, HellKnight**.
- Bosses' health is scaled as before (controlled via config variable).


### BETA 5:
- Made compatible with 1035 patch
- Sharpshooter receives normal headshot multiplier bonus for perked weapons
  (not only 50% like it was in Doom3KFBeta4 + 1035)
- Big doom monsters get 30% damage resistance from Xbow/M99 headshots on Sui/Hoe
  Resistance is applied to Bruiser, Archvile, Mancubus, HellKnight and all bosses
- PatBossMult variable added, allowing to make Pat Replacement bosses to have
  more health comparing to regular, in-wave bosses
- Removed Sentry turret
- ~Fixed Ragdoll death animation replication on client side~
- Fixed Mac10 burning
- Imp's fireballs now sets players on fire (but base damage is lowered by 25%)
- Imp and Archive now can't be set on fire

##### Bosses
- Bounty for killing bosses significantly increased and it raises
  per player with same rate as health (BossPerPlayerHP)
- Maledict's base health lowered to 4000 (down from 6000)
- Changed PAT wave: now Doom Boss periodically will spawn demons to help him
- When Boss is spawning as Pat replacement, he receives extra 75% resistance to fire DoT

#### New Burning Mechanism
- Zeds require significantly more damage to ignite, but when do, they receive constant, average damage per burn tick.
- Ignition requirement: Deal burn damage at least *3% of zed's max health, 75 max*
- Walk animations while burning fixed.

##### Damage per Tick
- **MAC10**: `53` (constant)
- Other weapons: `((base damage * 1.5) + 27) * (firebug damage bonus)`
  For example level 6 firebug flamer's tick damage is 72.
- Tick count is lowered to 8 (down from 10), but each next fire damage received will
  continue burning (reset tick count back to 8 again).
- Burn continuation is possible only when dealing the same or higher fire damage,
  e.g. you can't keep zed burning with shooting with MAC10 after flame nade.
