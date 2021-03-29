///////////////////////////////////////////////////////////////////////////////
// ARGUMENTS
///////////////////////////////////////////////////////////////////////////////

var target = Argument("target", "Publish");

var packageInfo = new ChocolateyPackSettings
{
    //PACKAGE SPECIFIC SECTION
    Id = "krew",
    Version = "0.4.1",
    PackageSourceUrl = new Uri("https://github.com/zverev-iv/choco-krew"),
    Owners = new[] { "zverev-iv" },
    //SOFTWARE SPECIFIC SECTION
    Title = "Krew",
    Authors = new[] {
        "The Kubernetes Authors"
        },
    Copyright = "2021 The Kubernetes Authors",
    ProjectUrl = new Uri("https://krew.sigs.k8s.io/"),
    ProjectSourceUrl = new Uri("https://github.com/kubernetes-sigs/krew"),
    DocsUrl = new Uri("https://krew.sigs.k8s.io/docs/"),
    BugTrackerUrl = new Uri("https://github.com/kubernetes-sigs/krew/issues"),
    MailingListUrl = new Uri("https://groups.google.com/forum/#!forum/kubernetes-sig-cli"),
    IconUrl = new Uri("https://cdn.statically.io/gh/kubernetes-sigs/krew/master/assets/logo/icon/color/krew-icon-color.png"),
    LicenseUrl = new Uri("https://raw.githubusercontent.com/kubernetes-sigs/krew/master/LICENSE"),
    RequireLicenseAcceptance = false,
    Summary = "Krew is the package manager for kubectl plugins",
    Description = @"Krew is a tool that makes it easy to use kubectl plugins. Krew helps you discover plugins, install and manage them on your machine. It is similar to tools like apt, dnf or brew. Today, over 100 kubectl plugins are available on Krew.

- For kubectl users: Krew helps you find, install and manage kubectl plugins in a consistent way.
- For plugin developers: Krew helps you package and distribute your plugins on multiple platforms and makes them discoverable.",
    ReleaseNotes = new[] { "https://github.com/kubernetes-sigs/krew/releases" },
    Files = new[] {
        new ChocolateyNuSpecContent {Source = System.IO.Path.Combine("src", "**"), Target = "tools"}
        },
    Tags = new[] {
        "krew",
        "kubernetes",
        "container",
        "containerd",
        "plugin",
        "plugins",
        "portable"
        },
    Dependencies = new[] {
        new ChocolateyNuSpecDependency {
            Id = "git",
            Version = "2.28.0"
        }
    }
};

///////////////////////////////////////////////////////////////////////////////
// SETUP / TEARDOWN
///////////////////////////////////////////////////////////////////////////////

Setup(ctx =>
{
   // Executed BEFORE the first task.
   Information("Running tasks...");
});

Teardown(ctx =>
{
   // Executed AFTER the last task.
   Information("Finished running tasks.");
});

///////////////////////////////////////////////////////////////////////////////
// TASKS
///////////////////////////////////////////////////////////////////////////////

Task("Clean")
    .Does(() =>
{
    DeleteFiles("./**/*.nupkg");
    DeleteFiles("./**/*.nuspec");
});

Task("Pack")
    .IsDependentOn("Clean")
    .Does(() =>
{
    ChocolateyPack(packageInfo);
});

Task("Publish")
    .IsDependentOn("Pack")
    .Does(() =>
{
    var publishKey = EnvironmentVariable<string>("CHOCOAPIKEY", null);
    var package = $"{packageInfo.Id}.{packageInfo.Version}.nupkg";

    ChocolateyPush(package, new ChocolateyPushSettings
    {
        ApiKey = publishKey
    });
});

//////////////////////////////////////////////////////////////////////
// EXECUTION
//////////////////////////////////////////////////////////////////////

RunTarget(target);
