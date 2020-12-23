import { computeBoxProps } from "./Box";
import { Component } from "inferno";

// TODO: This and InfinitePlane are near identical except for the zoom functionality
// Figure out how to compartmentalize that better
export class Draggable extends Component {
  constructor() {
    super();

    this.state = {
      mouseDown: false,

      left: 0,
      top: 0,

      lastLeft: 0,
      lastTop: 0,
    };

    this.onMouseDown = this.onMouseDown.bind(this);
    this.onMouseMove = this.onMouseMove.bind(this);
    this.onMouseUp = this.onMouseUp.bind(this);
  }

  componentDidMount() {
    window.addEventListener("mouseup", this.onMouseUp);
  }

  componentWillUnmount() {
    window.removeEventListener("mouseup", this.onMouseUp);
  }

  onMouseDown(event) {
    this.setState((state) => {
      return {
        mouseDown: true,
        lastLeft: event.clientX - state.left,
        lastTop: event.clientY - state.top,
      };
    });
  }

  onMouseMove(event) {
    if (this.state.mouseDown) {
      this.setState((state) => {
        const newPosition = {
          left: event.clientX - state.lastLeft,
          top: event.clientY - state.lastTop,
        };

        if (this.props.onMove !== undefined) {
          this.props.onMove(newPosition);
        }

        return newPosition;
      });
    }
  }

  onMouseUp() {
    this.setState({
      mouseDown: false,
    });
  }

  render() {
    const {
      children,
      ...rest
    } = this.props;

    const {
      left,
      top,
    } = this.state;

    return (<span
      ref={this.ref}
      {...computeBoxProps({
        ...rest,

        onMouseDown: this.onMouseDown,
        onMouseMove: this.onMouseMove,

        style: {
          ...rest.style,
          "background": "purple",
          "overflow": "hidden",
          "pointer-events": "all", // TODO: This isn't necessary, use SCSS to make InfinitePlane's children have pointer-events: all instead
          "position": "relative",
          "transform": `translate(${left}px, ${top}px)`,
        },
      })}
    >
      {children}
    </span>);
  }
}
