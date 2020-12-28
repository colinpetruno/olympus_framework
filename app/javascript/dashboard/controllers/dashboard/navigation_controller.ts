import { Controller } from "stimulus";

interface ClassMap {
  [name: string]: string;
}

export default class extends Controller {
  element: HTMLElement;
  classMap: ClassMap = {
    "calendars": ".dashboard-left_navigation_pane-calendars",
    "company": ".dashboard-left_navigation_pane-company",
    "teams": ".dashboard-left_navigation_pane-team_list",
    "your_dashboard": ".dashboard-left_navigation_pane-calendar"
  }
  collapseSidebar: any;

  connect () {
    this.collapseSidebar = $(".collapsing-nav");
  }

  updateTab (event: any, something: any) {
    event.preventDefault();
    let targetTab = $(event.target).closest("a").data("tabname");

    $("#LeftNavPaneContent").find(".active").removeClass("active");
    $("#LeftNavPaneContent " + this.classMap[targetTab]).addClass("active");
  }

  toggleSideMenu () {
    this.collapseSidebar[0].classList.toggle("closed");

    localStorage.setItem(
      "navigationClosed", 
      $(this.collapseSidebar).hasClass("closed").toString()
    );
  }
}
