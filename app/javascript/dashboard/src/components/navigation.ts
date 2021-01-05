class Navigation {
  private collapseSidebarSelector = ".collapsing-nav";
  private collapseSidebar: HTMLElement;
  private navigationPane: HTMLElement;
  private navigationPaneSelector = ".layouts-dashboard-left_navigation_pane";
  private navigationToggle: HTMLElement;
  private navigationToggleSelector = ".nav-toggle";

  constructor() {
    this.navigationPane = document.querySelector(
      this.navigationPaneSelector
    ) as HTMLElement;

    this.collapseSidebar = document.querySelector(
      this.collapseSidebarSelector
    ) as HTMLElement;

    this.navigationToggle = document.querySelector(
      this.navigationPaneSelector + " " + this.navigationToggleSelector
    ) as HTMLElement;

    this.setup();
  }

  setup() {
    // The onboarding layout may not have the nav pane on the left
    if(!this.navigationPane) {
      return;
    }
  }

  toggleNavigation() {
    localStorage.setItem(
      "navigationClosed", 
      $(this.collapseSidebar).hasClass("closed").toString()
    );
  }

  openNav() {
    this.collapseSidebar.classList.remove("closed");
  }

  closeNav() {
    this.collapseSidebar.classList.add("closed");
  }

  isOpen(): boolean {
    return !this.isClosed();
  }

  isClosed(): boolean {
    return this.collapseSidebar.classList.contains("closed");
  }
}

export { Navigation };
