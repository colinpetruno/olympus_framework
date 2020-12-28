import { Components } from './components';

class Wisp {
  private componentAdaptor: Components;

  constructor() {
  }

  setup() {
    this.components();
  }

  components(componentName?: string) {
    if(!this.componentAdaptor) {
      this.componentAdaptor = new Components();
      this.componentAdaptor.setup();
    }

    if (componentName) {
      return this.componentAdaptor.getComponent(componentName);
    } else {
      return this.componentAdaptor;
    }
  }
}

export default Wisp;
