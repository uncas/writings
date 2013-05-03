Git Rebase Talk
===============

Appetizer
---------

'Git som redigeringsværktøj'

Jeg vil tale om og vise nogle workflows i git,
der gør det muligt at udforme ændringer i git præcist som du ønsker det,
eller rette op på tidligere 'uheldige' ændringer.

Det kan måske hjælpe med at besvare nogle af følgende spørgsmål eller løse nogle af følgende situationer:
- Hvis du bruger git har du måske set en historik med masser af merges mellem forskellige branches 
  eller masser af merges mellem enkelt-commits fra flere team-medlemmer.
- Hvordan er det muligt at få et samlet overblik over hvad de forskellige ændringer hører til/sammen med?
- Hvordan finder du ud af hvad du egentligt har ændret?
- Hvad gør du hvis du har lavet en fejl, men allerede committet eller allerede pushet til andre?
- Foretrækker du 'write-time convenience' eller 'read-time convenience'?
- Hvad kan du gøre for løbende at holde historikken så simpel som muligt?
- Hvordan finder du ud af hvor det gik galt?


Flows
-----

Non-editing flows:
- A1: work on same branch
- A2: work on two branches (master and develop)
- simple merge on branch
- pull with merge
- merge to master and resulting history

Basic editing flows:
- B1: commit --amend
-- reflog
- B2: cherry-pick <sha>
- B3: pull with rebase

Advanced editing flows:
- C1: rebase -i with squash, fix, reorder, reword, omit
- C2: rebase -i origin/develop (before pushing local changes from 'develop' to 'origin/develop')
- C3: rebase -i master (before merging changes from 'develop' to 'master')

Extra:
- D1: bisect
-- Linear is easier to visualize and takes fewer steps
-- Rebase to remove compile errors
-- Rebase to compile many small commits into logical units such that bisect is more logically correct

Benefits of 'editing flows':
- bisect gets easier
- you can easier see what you have changed
- other people can easier review what you have changed
- the commits and commit comments make more sense as self-contained changes
