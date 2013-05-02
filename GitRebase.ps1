function Cleanup {
	if (Test-Path GitRebaseExamples) {
		rmdir -force -recurse GitRebaseExamples
	}
}

function PrepareClone ($name, $remote = "mother") {
    git clone $remote $name
    cd $name
    git config user.email "$name@example.com"
    git config user.name $name
    cd ..
}

function InitializeBranch ($repo = "alpha") {
    cd $repo
    Set-Content readme.txt "Readme"
    git add .
    git commit -m "Add readme."
    git push
    cd ..
}

function AddCommit ($name) {
    $fileName = "todo-$name.txt"
    if (Test-Path $fileName) {
        $content = Get-Content $fileName
    }
    $content += "More stuff.
"
    Set-Content $fileName $content
    git add .
    git commit -m "Update todo."
}

function AddTodoStuff ($fileName) {
    if (Test-Path $fileName) {
        $content = Get-Content $fileName
    }
    $content += "More stuff.
"
    Set-Content $fileName $content
    git add .
    git commit -m "Update $fileName"
}

function AddCommitsPullPush ($name) {
    cd $name
    #AddCommit $name
    AddCommit $name
    git pull
    git push
    cd ..
}

function AddCommitsPullRebasePush ($name) {
    cd $name
    AddCommit $name
    AddCommit $name
    git pull --rebase
    git push
    cd ..
}

function AnalyzeResult {
    cd mother
    $commitCount = (git log --oneline).count
    $mergeCount = (git log --oneline --merges).count
    $mergePercentage = $mergeCount / $commitCount * 100
    Write-Host "$commitCount commits, $mergeCount merges ($mergePercentage %)"
    cd ..
}

function AnalyzeWorkflow {
	git init mother --bare
	PrepareClone "alpha"
	InitializeBranch
	PrepareClone "beta"
	PrepareClone "gamma"
	for ($i = 0; $i -lt 3; $i++) {
		AddCommitsPullPush "alpha"
		AddCommitsPullPush "beta"
		AddCommitsPullPush "gamma"
	}
	AnalyzeResult
}

function ContributeStuff ($repo, $file) {
	cd $repo
		AddTodoStuff $file
		git pull --rebase
		git push
	cd ..
}

function ScenarioA1 {
	git init A1-mother --bare
	
	git clone A1-mother A1-alpha
		cd A1-alpha
		git config user.name "alpha"
		git config user.email "alpha@example.com"
		Set-Content readme.txt "Readme"
		git add .
		git commit -m "Add readme."
		git push
	cd ..

	ContributeStuff "A1-alpha" "todo-alpha.txt"
	
	git clone A1-mother A1-beta
		cd A1-beta
		git config user.name "beta"
		git config user.email "beta@example.com"
	cd ..
	
	git clone A1-mother A1-gamma
		cd A1-gamma
		git config user.name "gamma"
		git config user.email "gamma@example.com"
	cd ..
	
	git clone A1-mother A1-delta
		cd A1-delta
		git config user.name "delta"
		git config user.email "delta@example.com"
	cd ..
	
	for ($i = 0; $i -lt 3; $i++) {
		ContributeStuff "A1-alpha" "todo-alpha.txt"
		ContributeStuff "A1-delta" "todo-delta.txt"
		ContributeStuff "A1-delta" "todo-delta.txt"
		ContributeStuff "A1-beta" "todo-beta.txt"
		ContributeStuff "A1-gamma" "todo-gamma.txt"
		ContributeStuff "A1-delta" "todo-delta.txt"
		ContributeStuff "A1-beta" "todo-beta.txt"
		ContributeStuff "A1-alpha" "todo-alpha.txt"
		ContributeStuff "A1-delta" "todo-delta.txt"
		ContributeStuff "A1-gamma" "todo-gamma.txt"
		ContributeStuff "A1-beta" "todo-beta.txt"
		ContributeStuff "A1-gamma" "todo-gamma.txt"
		ContributeStuff "A1-delta" "todo-delta.txt"
		ContributeStuff "A1-alpha" "todo-alpha.txt"
		ContributeStuff "A1-beta" "todo-beta.txt"
		ContributeStuff "A1-delta" "todo-delta.txt"
		ContributeStuff "A1-gamma" "todo-gamma.txt"
		ContributeStuff "A1-alpha" "todo-alpha.txt"
		ContributeStuff "A1-delta" "todo-delta.txt"
		ContributeStuff "A1-beta" "todo-beta.txt"
		ContributeStuff "A1-alpha" "todo-alpha.txt"
		ContributeStuff "A1-delta" "todo-delta.txt"
		ContributeStuff "A1-gamma" "todo-gamma.txt"
	}

	cd A1-alpha
	git lol
	cd ..
}

function ScenarioA2 {
	git init A2-mother --bare
	
	git clone A2-mother A2-alpha
		cd A2-alpha
		git config user.name "alpha"
		git config user.email "alpha@example.com"
		Set-Content readme.txt "Readme"
		git add .
		git commit -m "Add readme."
		git push
	cd ..

	git clone A2-mother A2-beta
		cd A2-beta
		git config user.name "beta"
		git config user.email "beta@example.com"
	cd ..

	cd A2-alpha
		git checkout -b alpha
		git push -u origin alpha
	cd ..
	
	for ($i = 0; $i -lt 3; $i++) {
		cd A2-beta
			AddTodoStuff "todo-beta.txt"
			git pull
			git push
		cd ..

		cd A2-alpha
			AddTodoStuff "todo-alpha.txt"
			git pull
			git push . origin/master:master
			git merge master
			git push
		cd ..
	}

	cd A2-alpha
	git lol
	cd ..
}

function ScenarioB1 {
	git init B1-repo
	cd B1-repo
		git config user.name "B1"
		Set-Content readme.txt "Please read me first."
		git add .
		git commit -m "Add readme file."
		AddTodoStuff "todo.txt"
		AddTodoStuff "todo.txt"
		AddTodoStuff "todo.txt"
		Set-Content todo.txt "Woops"
		git add .
		git commit -m "Woops!"
	cd ..
}

function ScenarioB2 {
	git init B2-repo
	cd B2-repo
		git config user.name "B2"
		Set-Content readme.txt "Please read me first."
		git add .
		git commit -m "Add readme file."
		AddTodoStuff "todo.txt"
		git checkout -b alpha
		AddTodoStuff "dev.txt"
		AddTodoStuff "dev.txt"
		AddTodoStuff "brilliant.txt"
		git checkout -b beta master
		AddTodoStuff "todo.txt"
		AddTodoStuff "todo.txt"
		AddTodoStuff "todo.txt"
	cd ..
}

function ScenarioB3 {
	git init B3-mother --bare
	git clone B3-mother B3-alpha
	cd B3-alpha
		git config user.name "B3"
		Set-Content readme.txt "Please read me first."
		git add .
		git commit -m "Add readme file."
		git push
		AddTodoStuff "alpha.txt"
	cd ..
	git clone B3-mother B3-beta
	cd B3-beta
		AddTodoStuff "beta.txt"
		git push
	cd ..
}

Cleanup
mkdir GitRebaseExamples
cd GitRebaseExamples
	#AnalyzeWorkflow
	#ScenarioA1
	#ScenarioA2
	ScenarioB1
	ScenarioB2
	ScenarioB3
cd ..
